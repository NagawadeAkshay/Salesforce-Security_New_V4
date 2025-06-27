/*
    Metadata Service class generated from WSDL
*/
public with sharing class MetadataService {
    public with sharing class listMetadataResponse_element {
        public MetadataService.FileProperties[] result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class WorkflowRule extends Metadata {
        public String type = 'WorkflowRule';
        public String fullName;
        public MetadataService.WorkflowActionReference[] actions;
        public Boolean active;
        public String booleanFilter;
        public MetadataService.FilterItem[] criteriaItems;
        public String description;
        public String formula;
        public String triggerType;
        public MetadataService.WorkflowTimeTrigger[] workflowTimeTriggers;
        private String[] actions_type_info = new String[]{'actions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] criteriaItems_type_info = new String[]{'criteriaItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] formula_type_info = new String[]{'formula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] triggerType_type_info = new String[]{'triggerType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] workflowTimeTriggers_type_info = new String[]{'workflowTimeTriggers','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'actions','active','booleanFilter','criteriaItems','description','formula','triggerType','workflowTimeTriggers'};
    }
    public with sharing class FieldOverride {
        public String field;
        public String formula;
        public String literalValue;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] formula_type_info = new String[]{'formula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] literalValue_type_info = new String[]{'literalValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','formula','literalValue'};
    }
    public with sharing class AccountOwnerSharingRule {
        public String accountAccessLevel;
        public String caseAccessLevel;
        public String contactAccessLevel;
        public String description;
        public String name;
        public String opportunityAccessLevel;
        private String[] accountAccessLevel_type_info = new String[]{'accountAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] caseAccessLevel_type_info = new String[]{'caseAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] contactAccessLevel_type_info = new String[]{'contactAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] opportunityAccessLevel_type_info = new String[]{'opportunityAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accountAccessLevel','caseAccessLevel','contactAccessLevel','description','name','opportunityAccessLevel'};
    }
    public with sharing class QuotasSettings {
        public Boolean showQuotas;
        private String[] showQuotas_type_info = new String[]{'showQuotas','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'showQuotas'};
    }
    public with sharing class checkDeployStatus_element {
        public String asyncProcessId;
        public Boolean includeDetails;
        private String[] asyncProcessId_type_info = new String[]{'asyncProcessId','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] includeDetails_type_info = new String[]{'includeDetails','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'asyncProcessId','includeDetails'};
    }
    public with sharing class Skill extends Metadata {
        public String type = 'Skill';
        public String fullName;
        public MetadataService.SkillAssignments assignments;
        public String label;
        private String[] assignments_type_info = new String[]{'assignments','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'assignments','label'};
    }
    public with sharing class CodeCoverageWarning {
        public String id;
        public String message;
        public String name;
        public String namespace;
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] message_type_info = new String[]{'message','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] namespace_type_info = new String[]{'namespace','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'id','message','name','namespace'};
    }
    public with sharing class FlowInputValidationRule {
        public String errorMessage;
        public String formulaExpression;
        private String[] errorMessage_type_info = new String[]{'errorMessage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] formulaExpression_type_info = new String[]{'formulaExpression','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'errorMessage','formulaExpression'};
    }
    public with sharing class FlowApexPluginCall {
        public String apexClass;
        public MetadataService.FlowConnector connector;
        public MetadataService.FlowConnector faultConnector;
        public MetadataService.FlowApexPluginCallInputParameter[] inputParameters;
        public MetadataService.FlowApexPluginCallOutputParameter[] outputParameters;
        private String[] apexClass_type_info = new String[]{'apexClass','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] faultConnector_type_info = new String[]{'faultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inputParameters_type_info = new String[]{'inputParameters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] outputParameters_type_info = new String[]{'outputParameters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apexClass','connector','faultConnector','inputParameters','outputParameters'};
    }
    public with sharing class CustomObjectCriteriaBasedSharingRule {
        public String accessLevel;
        public String booleanFilter;
        public String description;
        public String name;
        private String[] accessLevel_type_info = new String[]{'accessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accessLevel','booleanFilter','description','name'};
    }
    public with sharing class KnowledgeAnswerSettings {
        public String assignTo;
        public String defaultArticleType;
        public Boolean enableArticleCreation;
        private String[] assignTo_type_info = new String[]{'assignTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultArticleType_type_info = new String[]{'defaultArticleType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableArticleCreation_type_info = new String[]{'enableArticleCreation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignTo','defaultArticleType','enableArticleCreation'};
    }
    public with sharing class PasswordPolicies {
        public String apiOnlyUserHomePageURL;
        public String complexity;
        public String expiration;
        public String historyRestriction;
        public String lockoutInterval;
        public String maxLoginAttempts;
        public String minPasswordLength;
        public Boolean minimumPasswordLifetime;
        public Boolean obscureSecretAnswer;
        public String passwordAssistanceMessage;
        public String passwordAssistanceURL;
        public String questionRestriction;
        private String[] apiOnlyUserHomePageURL_type_info = new String[]{'apiOnlyUserHomePageURL','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] complexity_type_info = new String[]{'complexity','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] expiration_type_info = new String[]{'expiration','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] historyRestriction_type_info = new String[]{'historyRestriction','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lockoutInterval_type_info = new String[]{'lockoutInterval','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] maxLoginAttempts_type_info = new String[]{'maxLoginAttempts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] minPasswordLength_type_info = new String[]{'minPasswordLength','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] minimumPasswordLifetime_type_info = new String[]{'minimumPasswordLifetime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] obscureSecretAnswer_type_info = new String[]{'obscureSecretAnswer','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] passwordAssistanceMessage_type_info = new String[]{'passwordAssistanceMessage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] passwordAssistanceURL_type_info = new String[]{'passwordAssistanceURL','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] questionRestriction_type_info = new String[]{'questionRestriction','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apiOnlyUserHomePageURL','complexity','expiration','historyRestriction','lockoutInterval','maxLoginAttempts','minPasswordLength','minimumPasswordLifetime','obscureSecretAnswer','passwordAssistanceMessage','passwordAssistanceURL','questionRestriction'};
    }
    public with sharing class QueueSobject {
        public String sobjectType;
        private String[] sobjectType_type_info = new String[]{'sobjectType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'sobjectType'};
    }
    public with sharing class CaseSharingRules {
        public MetadataService.CaseCriteriaBasedSharingRule[] criteriaBasedRules;
        public MetadataService.CaseOwnerSharingRule[] ownerRules;
        private String[] criteriaBasedRules_type_info = new String[]{'criteriaBasedRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] ownerRules_type_info = new String[]{'ownerRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaBasedRules','ownerRules'};
    }
    public with sharing class AgentConfigProfileAssignments {
        public String[] profile;
        private String[] profile_type_info = new String[]{'profile','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'profile'};
    }
    public with sharing class OpportunityOwnerSharingRule {
        public String description;
        public String name;
        public String opportunityAccessLevel;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] opportunityAccessLevel_type_info = new String[]{'opportunityAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','name','opportunityAccessLevel'};
    }
    public with sharing class ExternalDataSource extends Metadata {
        public String type = 'ExternalDataSource';
        public String fullName;
        public String apiKey;
        public String authProvider;
        public String certificate;
        public String customConfiguration;
        public String endpoint;
        public String label;
        public String oauthRefreshToken;
        public String oauthScope;
        public String oauthToken;
        public String password;
        public String principalType;
        public String protocol;
        public String repository;
        public String type_x;
        public String username;
        public String version;
        private String[] apiKey_type_info = new String[]{'apiKey','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] authProvider_type_info = new String[]{'authProvider','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] certificate_type_info = new String[]{'certificate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customConfiguration_type_info = new String[]{'customConfiguration','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] endpoint_type_info = new String[]{'endpoint','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] oauthRefreshToken_type_info = new String[]{'oauthRefreshToken','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] oauthScope_type_info = new String[]{'oauthScope','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] oauthToken_type_info = new String[]{'oauthToken','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] principalType_type_info = new String[]{'principalType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] protocol_type_info = new String[]{'protocol','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] repository_type_info = new String[]{'repository','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] username_type_info = new String[]{'username','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] version_type_info = new String[]{'version','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'apiKey','authProvider','certificate','customConfiguration','endpoint','label','oauthRefreshToken','oauthScope','oauthToken','password','principalType','protocol','repository','type_x','username','version'};
    }
    public with sharing class WorkflowEmailRecipient {
        public String field;
        public String recipient;
        public String type_x;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recipient_type_info = new String[]{'recipient','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','recipient','type_x'};
    }
    public with sharing class DescribeMetadataResult {
        public MetadataService.DescribeMetadataObject[] metadataObjects;
        public String organizationNamespace;
        public Boolean partialSaveAllowed;
        public Boolean testRequired;
        private String[] metadataObjects_type_info = new String[]{'metadataObjects','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] organizationNamespace_type_info = new String[]{'organizationNamespace','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] partialSaveAllowed_type_info = new String[]{'partialSaveAllowed','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] testRequired_type_info = new String[]{'testRequired','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'metadataObjects','organizationNamespace','partialSaveAllowed','testRequired'};
    }
    public with sharing class Scontrol extends MetadataWithContent {
        public String type = 'Scontrol';
        public String fullName;
        public String content;
        public String contentSource;
        public String description;
        public String encodingKey;
        public String fileContent;
        public String fileName;
        public String name;
        public Boolean supportsCaching;
        private String[] contentSource_type_info = new String[]{'contentSource','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] encodingKey_type_info = new String[]{'encodingKey','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fileContent_type_info = new String[]{'fileContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fileName_type_info = new String[]{'fileName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] supportsCaching_type_info = new String[]{'supportsCaching','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'contentSource','description','encodingKey','fileContent','fileName','name','supportsCaching'};
    }
    public with sharing class DashboardComponent {
        public Boolean autoselectColumnsFromReport;
        public String chartAxisRange;
        public Double chartAxisRangeMax;
        public Double chartAxisRangeMin;
        public MetadataService.ChartSummary[] chartSummary;
        public String componentType;
        public MetadataService.DashboardFilterColumn[] dashboardFilterColumns;
        public MetadataService.DashboardTableColumn[] dashboardTableColumn;
        public String displayUnits;
        public String drillDownUrl;
        public Boolean drillEnabled;
        public Boolean drillToDetailEnabled;
        public Boolean enableHover;
        public Boolean expandOthers;
        public String footer;
        public Double gaugeMax;
        public Double gaugeMin;
        public String[] groupingColumn;
        public String header;
        public Double indicatorBreakpoint1;
        public Double indicatorBreakpoint2;
        public String indicatorHighColor;
        public String indicatorLowColor;
        public String indicatorMiddleColor;
        public String legendPosition;
        public Integer maxValuesDisplayed;
        public String metricLabel;
        public String page_x;
        public Integer pageHeightInPixels;
        public String report;
        public String scontrol;
        public Integer scontrolHeightInPixels;
        public Boolean showPercentage;
        public Boolean showPicturesOnCharts;
        public Boolean showPicturesOnTables;
        public Boolean showTotal;
        public Boolean showValues;
        public String sortBy;
        public String title;
        public Boolean useReportChart;
        private String[] autoselectColumnsFromReport_type_info = new String[]{'autoselectColumnsFromReport','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chartAxisRange_type_info = new String[]{'chartAxisRange','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chartAxisRangeMax_type_info = new String[]{'chartAxisRangeMax','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chartAxisRangeMin_type_info = new String[]{'chartAxisRangeMin','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chartSummary_type_info = new String[]{'chartSummary','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] componentType_type_info = new String[]{'componentType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] dashboardFilterColumns_type_info = new String[]{'dashboardFilterColumns','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] dashboardTableColumn_type_info = new String[]{'dashboardTableColumn','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] displayUnits_type_info = new String[]{'displayUnits','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] drillDownUrl_type_info = new String[]{'drillDownUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] drillEnabled_type_info = new String[]{'drillEnabled','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] drillToDetailEnabled_type_info = new String[]{'drillToDetailEnabled','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableHover_type_info = new String[]{'enableHover','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] expandOthers_type_info = new String[]{'expandOthers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] footer_type_info = new String[]{'footer','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] gaugeMax_type_info = new String[]{'gaugeMax','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] gaugeMin_type_info = new String[]{'gaugeMin','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] groupingColumn_type_info = new String[]{'groupingColumn','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] header_type_info = new String[]{'header','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] indicatorBreakpoint1_type_info = new String[]{'indicatorBreakpoint1','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] indicatorBreakpoint2_type_info = new String[]{'indicatorBreakpoint2','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] indicatorHighColor_type_info = new String[]{'indicatorHighColor','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] indicatorLowColor_type_info = new String[]{'indicatorLowColor','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] indicatorMiddleColor_type_info = new String[]{'indicatorMiddleColor','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] legendPosition_type_info = new String[]{'legendPosition','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] maxValuesDisplayed_type_info = new String[]{'maxValuesDisplayed','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] metricLabel_type_info = new String[]{'metricLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] pageHeightInPixels_type_info = new String[]{'pageHeightInPixels','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] report_type_info = new String[]{'report','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scontrol_type_info = new String[]{'scontrol','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scontrolHeightInPixels_type_info = new String[]{'scontrolHeightInPixels','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showPercentage_type_info = new String[]{'showPercentage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showPicturesOnCharts_type_info = new String[]{'showPicturesOnCharts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showPicturesOnTables_type_info = new String[]{'showPicturesOnTables','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showTotal_type_info = new String[]{'showTotal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showValues_type_info = new String[]{'showValues','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortBy_type_info = new String[]{'sortBy','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] title_type_info = new String[]{'title','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] useReportChart_type_info = new String[]{'useReportChart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'autoselectColumnsFromReport','chartAxisRange','chartAxisRangeMax','chartAxisRangeMin','chartSummary','componentType','dashboardFilterColumns','dashboardTableColumn','displayUnits','drillDownUrl','drillEnabled','drillToDetailEnabled','enableHover','expandOthers','footer','gaugeMax','gaugeMin','groupingColumn','header','indicatorBreakpoint1','indicatorBreakpoint2','indicatorHighColor','indicatorLowColor','indicatorMiddleColor','legendPosition','maxValuesDisplayed','metricLabel','page_x','pageHeightInPixels','report','scontrol','scontrolHeightInPixels','showPercentage','showPicturesOnCharts','showPicturesOnTables','showTotal','showValues','sortBy','title','useReportChart'};
    }
    public with sharing class WorkflowFlowActionParameter {
        public String name;
        public String value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class IdeasSettings extends Metadata {
        public String type = 'IdeasSettings';
        public String fullName;
        public Boolean enableChatterProfile;
        public Boolean enableIdeaThemes;
        public Boolean enableIdeas;
        public Boolean enableIdeasReputation;
        public Double halfLife;
        public String ideasProfilePage;
        private String[] enableChatterProfile_type_info = new String[]{'enableChatterProfile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableIdeaThemes_type_info = new String[]{'enableIdeaThemes','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableIdeas_type_info = new String[]{'enableIdeas','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableIdeasReputation_type_info = new String[]{'enableIdeasReputation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] halfLife_type_info = new String[]{'halfLife','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] ideasProfilePage_type_info = new String[]{'ideasProfilePage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'enableChatterProfile','enableIdeaThemes','enableIdeas','enableIdeasReputation','halfLife','ideasProfilePage'};
    }
    public with sharing class Country {
        public Boolean active;
        public String integrationValue;
        public String isoCode;
        public String label;
        public Boolean orgDefault;
        public Boolean standard;
        public MetadataService.State[] states;
        public Boolean visible;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] integrationValue_type_info = new String[]{'integrationValue','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isoCode_type_info = new String[]{'isoCode','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] orgDefault_type_info = new String[]{'orgDefault','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] standard_type_info = new String[]{'standard','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] states_type_info = new String[]{'states','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] visible_type_info = new String[]{'visible','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'active','integrationValue','isoCode','label','orgDefault','standard','states','visible'};
    }
    public with sharing class ConnectedAppOauthConfig {
        public String callbackUrl;
        public String certificate;
        public String consumerKey;
        public String consumerSecret;
        public String[] scopes;
        private String[] callbackUrl_type_info = new String[]{'callbackUrl','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] certificate_type_info = new String[]{'certificate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] consumerKey_type_info = new String[]{'consumerKey','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] consumerSecret_type_info = new String[]{'consumerSecret','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scopes_type_info = new String[]{'scopes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'callbackUrl','certificate','consumerKey','consumerSecret','scopes'};
    }
    public with sharing class LiveAgentSettings extends Metadata {
        public String type = 'LiveAgentSettings';
        public String fullName;
        public Boolean enableLiveAgent;
        private String[] enableLiveAgent_type_info = new String[]{'enableLiveAgent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'enableLiveAgent'};
    }
    public with sharing class PermissionSetApexClassAccess {
        public String apexClass;
        public Boolean enabled;
        private String[] apexClass_type_info = new String[]{'apexClass','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apexClass','enabled'};
    }
    public with sharing class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] level_type_info = new String[]{'level','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }
    public with sharing class SkillAssignments {
        public MetadataService.SkillProfileAssignments profiles;
        public MetadataService.SkillUserAssignments users;
        private String[] profiles_type_info = new String[]{'profiles','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] users_type_info = new String[]{'users','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'profiles','users'};
    }
    public with sharing class ReputationLevels {
        public MetadataService.ChatterAnswersReputationLevel[] chatterAnswersReputationLevels;
        public MetadataService.IdeaReputationLevel[] ideaReputationLevels;
        private String[] chatterAnswersReputationLevels_type_info = new String[]{'chatterAnswersReputationLevels','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] ideaReputationLevels_type_info = new String[]{'ideaReputationLevels','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'chatterAnswersReputationLevels','ideaReputationLevels'};
    }
    public with sharing class ActivitiesSettings extends Metadata {
        public String type = 'ActivitiesSettings';
        public String fullName;
        public Boolean allowUsersToRelateMultipleContactsToTasksAndEvents;
        public Boolean enableActivityReminders;
        public Boolean enableClickCreateEvents;
        public Boolean enableDragAndDropScheduling;
        public Boolean enableEmailTracking;
        public Boolean enableEventScheduler;
        public Boolean enableGroupTasks;
        public Boolean enableListViewScheduling;
        public Boolean enableLogNote;
        public Boolean enableMultidayEvents;
        public Boolean enableRecurringEvents;
        public Boolean enableRecurringTasks;
        public Boolean enableSidebarCalendarShortcut;
        public Boolean enableSimpleTaskCreateUI;
        public Boolean enableUNSTaskDelegatedToNotifications;
        public String meetingRequestsLogo;
        public Boolean showCustomLogoMeetingRequests;
        public Boolean showEventDetailsMultiUserCalendar;
        public Boolean showHomePageHoverLinksForEvents;
        public Boolean showMyTasksHoverLinks;
        public Boolean showRequestedMeetingsOnHomePage;
        private String[] allowUsersToRelateMultipleContactsToTasksAndEvents_type_info = new String[]{'allowUsersToRelateMultipleContactsToTasksAndEvents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableActivityReminders_type_info = new String[]{'enableActivityReminders','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableClickCreateEvents_type_info = new String[]{'enableClickCreateEvents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableDragAndDropScheduling_type_info = new String[]{'enableDragAndDropScheduling','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableEmailTracking_type_info = new String[]{'enableEmailTracking','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableEventScheduler_type_info = new String[]{'enableEventScheduler','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableGroupTasks_type_info = new String[]{'enableGroupTasks','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableListViewScheduling_type_info = new String[]{'enableListViewScheduling','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableLogNote_type_info = new String[]{'enableLogNote','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableMultidayEvents_type_info = new String[]{'enableMultidayEvents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableRecurringEvents_type_info = new String[]{'enableRecurringEvents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableRecurringTasks_type_info = new String[]{'enableRecurringTasks','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSidebarCalendarShortcut_type_info = new String[]{'enableSidebarCalendarShortcut','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSimpleTaskCreateUI_type_info = new String[]{'enableSimpleTaskCreateUI','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableUNSTaskDelegatedToNotifications_type_info = new String[]{'enableUNSTaskDelegatedToNotifications','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] meetingRequestsLogo_type_info = new String[]{'meetingRequestsLogo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showCustomLogoMeetingRequests_type_info = new String[]{'showCustomLogoMeetingRequests','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showEventDetailsMultiUserCalendar_type_info = new String[]{'showEventDetailsMultiUserCalendar','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showHomePageHoverLinksForEvents_type_info = new String[]{'showHomePageHoverLinksForEvents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showMyTasksHoverLinks_type_info = new String[]{'showMyTasksHoverLinks','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showRequestedMeetingsOnHomePage_type_info = new String[]{'showRequestedMeetingsOnHomePage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'allowUsersToRelateMultipleContactsToTasksAndEvents','enableActivityReminders','enableClickCreateEvents','enableDragAndDropScheduling','enableEmailTracking','enableEventScheduler','enableGroupTasks','enableListViewScheduling','enableLogNote','enableMultidayEvents','enableRecurringEvents','enableRecurringTasks','enableSidebarCalendarShortcut','enableSimpleTaskCreateUI','enableUNSTaskDelegatedToNotifications','meetingRequestsLogo','showCustomLogoMeetingRequests','showEventDetailsMultiUserCalendar','showHomePageHoverLinksForEvents','showMyTasksHoverLinks','showRequestedMeetingsOnHomePage'};
    }
    public with sharing class WorkflowTaskTranslation {
        public String description;
        public String name;
        public String subject;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] subject_type_info = new String[]{'subject','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','name','subject'};
    }
    public with sharing class FlowElement {
        public String description;
        public String name;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','name'};
    }
    public with sharing class FlowInputFieldAssignment {
        public String field;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','value'};
    }
    public with sharing class DashboardComponentSection {
        public String columnSize;
        public MetadataService.DashboardComponent[] components;
        private String[] columnSize_type_info = new String[]{'columnSize','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] components_type_info = new String[]{'components','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'columnSize','components'};
    }
    public with sharing class FlowLoop {
        public String assignNextValueToReference;
        public String collectionReference;
        public String iterationOrder;
        public MetadataService.FlowConnector nextValueConnector;
        public MetadataService.FlowConnector noMoreValuesConnector;
        private String[] assignNextValueToReference_type_info = new String[]{'assignNextValueToReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] collectionReference_type_info = new String[]{'collectionReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] iterationOrder_type_info = new String[]{'iterationOrder','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] nextValueConnector_type_info = new String[]{'nextValueConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] noMoreValuesConnector_type_info = new String[]{'noMoreValuesConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignNextValueToReference','collectionReference','iterationOrder','nextValueConnector','noMoreValuesConnector'};
    }
    public with sharing class ReputationPointsRule {
        public String eventType;
        public Integer points;
        private String[] eventType_type_info = new String[]{'eventType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] points_type_info = new String[]{'points','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'eventType','points'};
    }
    public with sharing class FlowActionCallInputParameter {
        public String name;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class ReportTypeColumn {
        public Boolean checkedByDefault;
        public String displayNameOverride;
        public String field;
        public String table;
        private String[] checkedByDefault_type_info = new String[]{'checkedByDefault','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] displayNameOverride_type_info = new String[]{'displayNameOverride','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] table_type_info = new String[]{'table','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'checkedByDefault','displayNameOverride','field','table'};
    }
    public with sharing class LiveAgentConfig {
        public Boolean enableLiveChat;
        public Boolean openNewAccountSubtab;
        public Boolean openNewCaseSubtab;
        public Boolean openNewContactSubtab;
        public Boolean openNewLeadSubtab;
        public Boolean openNewVFPageSubtab;
        public MetadataService.PagesToOpen pagesToOpen;
        public Boolean showKnowledgeArticles;
        private String[] enableLiveChat_type_info = new String[]{'enableLiveChat','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] openNewAccountSubtab_type_info = new String[]{'openNewAccountSubtab','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] openNewCaseSubtab_type_info = new String[]{'openNewCaseSubtab','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] openNewContactSubtab_type_info = new String[]{'openNewContactSubtab','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] openNewLeadSubtab_type_info = new String[]{'openNewLeadSubtab','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] openNewVFPageSubtab_type_info = new String[]{'openNewVFPageSubtab','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] pagesToOpen_type_info = new String[]{'pagesToOpen','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showKnowledgeArticles_type_info = new String[]{'showKnowledgeArticles','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enableLiveChat','openNewAccountSubtab','openNewCaseSubtab','openNewContactSubtab','openNewLeadSubtab','openNewVFPageSubtab','pagesToOpen','showKnowledgeArticles'};
    }
    public with sharing class KnowledgeSitesSettings {
        public String[] site;
        private String[] site_type_info = new String[]{'site','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'site'};
    }
    public with sharing class UserSharingRules {
        public MetadataService.UserCriteriaBasedSharingRule[] criteriaBasedRules;
        public MetadataService.UserMembershipSharingRule[] membershipRules;
        private String[] criteriaBasedRules_type_info = new String[]{'criteriaBasedRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] membershipRules_type_info = new String[]{'membershipRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaBasedRules','membershipRules'};
    }
    public with sharing class CustomMetadata extends Metadata {
        public String type = 'CustomMetadata';
        public String fullName;
        public String description;
        public String label;
        public MetadataService.CustomMetadataValue[] values;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] values_type_info = new String[]{'values','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','label','values'};
    }
    public with sharing class VisualizationPlugin extends Metadata {
        public String type = 'VisualizationPlugin';
        public String fullName;
        public String description;
        public String developerName;
        public String icon;
        public String masterLabel;
        public MetadataService.VisualizationResource[] visualizationResources;
        public MetadataService.VisualizationType[] visualizationTypes;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] developerName_type_info = new String[]{'developerName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] icon_type_info = new String[]{'icon','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visualizationResources_type_info = new String[]{'visualizationResources','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] visualizationTypes_type_info = new String[]{'visualizationTypes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','developerName','icon','masterLabel','visualizationResources','visualizationTypes'};
    }
    public with sharing class ApprovalPageField {
        public String[] field;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field'};
    }
    public with sharing class FlowRule {
        public String conditionLogic;
        public MetadataService.FlowCondition[] conditions;
        public MetadataService.FlowConnector connector;
        public String label;
        private String[] conditionLogic_type_info = new String[]{'conditionLogic','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] conditions_type_info = new String[]{'conditions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'conditionLogic','conditions','connector','label'};
    }
    public with sharing class FlowRecordUpdate {
        public MetadataService.FlowConnector connector;
        public MetadataService.FlowConnector faultConnector;
        public MetadataService.FlowRecordFilter[] filters;
        public MetadataService.FlowInputFieldAssignment[] inputAssignments;
        public String inputReference;
        public String object_x;
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] faultConnector_type_info = new String[]{'faultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] filters_type_info = new String[]{'filters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] inputAssignments_type_info = new String[]{'inputAssignments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] inputReference_type_info = new String[]{'inputReference','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'connector','faultConnector','filters','inputAssignments','inputReference','object_x'};
    }
    public with sharing class CustomSite extends Metadata {
        public String type = 'CustomSite';
        public String fullName;
        public Boolean active;
        public Boolean allowHomePage;
        public Boolean allowStandardAnswersPages;
        public Boolean allowStandardIdeasPages;
        public Boolean allowStandardLookups;
        public Boolean allowStandardSearch;
        public String analyticsTrackingCode;
        public String authorizationRequiredPage;
        public String bandwidthExceededPage;
        public String changePasswordPage;
        public String chatterAnswersForgotPasswordConfirmPage;
        public String chatterAnswersForgotPasswordPage;
        public String chatterAnswersHelpPage;
        public String chatterAnswersLoginPage;
        public String chatterAnswersRegistrationPage;
        public String clickjackProtectionLevel;
        public MetadataService.SiteWebAddress[] customWebAddresses;
        public String description;
        public String favoriteIcon;
        public String fileNotFoundPage;
        public String genericErrorPage;
        public String guestProfile;
        public String inMaintenancePage;
        public String inactiveIndexPage;
        public String indexPage;
        public String masterLabel;
        public String myProfilePage;
        public String portal;
        public Boolean requireHttps;
        public Boolean requireInsecurePortalAccess;
        public String robotsTxtPage;
        public String rootComponent;
        public String selfRegPage;
        public String serverIsDown;
        public String siteAdmin;
        public MetadataService.SiteRedirectMapping[] siteRedirectMappings;
        public String siteTemplate;
        public String siteType;
        public String subdomain;
        public String urlPathPrefix;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] allowHomePage_type_info = new String[]{'allowHomePage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] allowStandardAnswersPages_type_info = new String[]{'allowStandardAnswersPages','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowStandardIdeasPages_type_info = new String[]{'allowStandardIdeasPages','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] allowStandardLookups_type_info = new String[]{'allowStandardLookups','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] allowStandardSearch_type_info = new String[]{'allowStandardSearch','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] analyticsTrackingCode_type_info = new String[]{'analyticsTrackingCode','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] authorizationRequiredPage_type_info = new String[]{'authorizationRequiredPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] bandwidthExceededPage_type_info = new String[]{'bandwidthExceededPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] changePasswordPage_type_info = new String[]{'changePasswordPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chatterAnswersForgotPasswordConfirmPage_type_info = new String[]{'chatterAnswersForgotPasswordConfirmPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chatterAnswersForgotPasswordPage_type_info = new String[]{'chatterAnswersForgotPasswordPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chatterAnswersHelpPage_type_info = new String[]{'chatterAnswersHelpPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chatterAnswersLoginPage_type_info = new String[]{'chatterAnswersLoginPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chatterAnswersRegistrationPage_type_info = new String[]{'chatterAnswersRegistrationPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] clickjackProtectionLevel_type_info = new String[]{'clickjackProtectionLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] customWebAddresses_type_info = new String[]{'customWebAddresses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] favoriteIcon_type_info = new String[]{'favoriteIcon','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fileNotFoundPage_type_info = new String[]{'fileNotFoundPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] genericErrorPage_type_info = new String[]{'genericErrorPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] guestProfile_type_info = new String[]{'guestProfile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inMaintenancePage_type_info = new String[]{'inMaintenancePage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inactiveIndexPage_type_info = new String[]{'inactiveIndexPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] indexPage_type_info = new String[]{'indexPage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] myProfilePage_type_info = new String[]{'myProfilePage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] portal_type_info = new String[]{'portal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] requireHttps_type_info = new String[]{'requireHttps','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] requireInsecurePortalAccess_type_info = new String[]{'requireInsecurePortalAccess','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] robotsTxtPage_type_info = new String[]{'robotsTxtPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] rootComponent_type_info = new String[]{'rootComponent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] selfRegPage_type_info = new String[]{'selfRegPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] serverIsDown_type_info = new String[]{'serverIsDown','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] siteAdmin_type_info = new String[]{'siteAdmin','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] siteRedirectMappings_type_info = new String[]{'siteRedirectMappings','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] siteTemplate_type_info = new String[]{'siteTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] siteType_type_info = new String[]{'siteType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] subdomain_type_info = new String[]{'subdomain','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] urlPathPrefix_type_info = new String[]{'urlPathPrefix','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','allowHomePage','allowStandardAnswersPages','allowStandardIdeasPages','allowStandardLookups','allowStandardSearch','analyticsTrackingCode','authorizationRequiredPage','bandwidthExceededPage','changePasswordPage','chatterAnswersForgotPasswordConfirmPage','chatterAnswersForgotPasswordPage','chatterAnswersHelpPage','chatterAnswersLoginPage','chatterAnswersRegistrationPage','clickjackProtectionLevel','customWebAddresses','description','favoriteIcon','fileNotFoundPage','genericErrorPage','guestProfile','inMaintenancePage','inactiveIndexPage','indexPage','masterLabel','myProfilePage','portal','requireHttps','requireInsecurePortalAccess','robotsTxtPage','rootComponent','selfRegPage','serverIsDown','siteAdmin','siteRedirectMappings','siteTemplate','siteType','subdomain','urlPathPrefix'};
    }
    public with sharing class ReportBlockInfo {
        public MetadataService.ReportAggregateReference[] aggregateReferences;
        public String blockId;
        public String joinTable;
        private String[] aggregateReferences_type_info = new String[]{'aggregateReferences','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] blockId_type_info = new String[]{'blockId','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] joinTable_type_info = new String[]{'joinTable','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'aggregateReferences','blockId','joinTable'};
    }
    public with sharing class describeMetadataResponse_element {
        public MetadataService.DescribeMetadataResult result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class CaseOwnerSharingRule {
        public String caseAccessLevel;
        public String description;
        public String name;
        private String[] caseAccessLevel_type_info = new String[]{'caseAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'caseAccessLevel','description','name'};
    }
    public with sharing class DeployMessage {
        public Boolean changed;
        public Integer columnNumber;
        public String componentType;
        public Boolean created;
        public DateTime createdDate;
        public Boolean deleted;
        public String fileName;
        public String fullName;
        public String id;
        public Integer lineNumber;
        public String problem;
        public String problemType;
        public Boolean success;
        private String[] changed_type_info = new String[]{'changed','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] columnNumber_type_info = new String[]{'columnNumber','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] componentType_type_info = new String[]{'componentType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] created_type_info = new String[]{'created','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] createdDate_type_info = new String[]{'createdDate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] deleted_type_info = new String[]{'deleted','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fileName_type_info = new String[]{'fileName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fullName_type_info = new String[]{'fullName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lineNumber_type_info = new String[]{'lineNumber','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] problem_type_info = new String[]{'problem','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] problemType_type_info = new String[]{'problemType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] success_type_info = new String[]{'success','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'changed','columnNumber','componentType','created','createdDate','deleted','fileName','fullName','id','lineNumber','problem','problemType','success'};
    }
    public with sharing class FlowSubflowInputAssignment {
        public String name;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class ReportType extends Metadata {
        public String type = 'ReportType';
        public String fullName;
        public Boolean autogenerated;
        public String baseObject;
        public String category;
        public Boolean deployed;
        public String description;
        public MetadataService.ObjectRelationship join_x;
        public String label;
        public MetadataService.ReportLayoutSection[] sections;
        private String[] autogenerated_type_info = new String[]{'autogenerated','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] baseObject_type_info = new String[]{'baseObject','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] category_type_info = new String[]{'category','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] deployed_type_info = new String[]{'deployed','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] join_x_type_info = new String[]{'join','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sections_type_info = new String[]{'sections','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'autogenerated','baseObject','category','deployed','description','join_x','label','sections'};
    }
    public with sharing class CustomPageWebLink extends Metadata {
        public String type = 'CustomPageWebLink';
        public String fullName;
        public String availability;
        public String description;
        public String displayType;
        public String encodingKey;
        public Boolean hasMenubar;
        public Boolean hasScrollbars;
        public Boolean hasToolbar;
        public Integer height;
        public Boolean isResizable;
        public String linkType;
        public String masterLabel;
        public String openType;
        public String page_x;
        public String position;
        public Boolean protected_x;
        public Boolean requireRowSelection;
        public String scontrol;
        public Boolean showsLocation;
        public Boolean showsStatus;
        public String url;
        public Integer width;
        private String[] availability_type_info = new String[]{'availability','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayType_type_info = new String[]{'displayType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] encodingKey_type_info = new String[]{'encodingKey','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hasMenubar_type_info = new String[]{'hasMenubar','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hasScrollbars_type_info = new String[]{'hasScrollbars','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hasToolbar_type_info = new String[]{'hasToolbar','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isResizable_type_info = new String[]{'isResizable','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] linkType_type_info = new String[]{'linkType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] openType_type_info = new String[]{'openType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] position_type_info = new String[]{'position','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] requireRowSelection_type_info = new String[]{'requireRowSelection','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scontrol_type_info = new String[]{'scontrol','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showsLocation_type_info = new String[]{'showsLocation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showsStatus_type_info = new String[]{'showsStatus','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] url_type_info = new String[]{'url','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'availability','description','displayType','encodingKey','hasMenubar','hasScrollbars','hasToolbar','height','isResizable','linkType','masterLabel','openType','page_x','position','protected_x','requireRowSelection','scontrol','showsLocation','showsStatus','url','width'};
    }
    public with sharing class CodeCoverageResult {
        public MetadataService.CodeLocation[] dmlInfo;
        public String id;
        public MetadataService.CodeLocation[] locationsNotCovered;
        public MetadataService.CodeLocation[] methodInfo;
        public String name;
        public String namespace;
        public Integer numLocations;
        public Integer numLocationsNotCovered;
        public MetadataService.CodeLocation[] soqlInfo;
        public MetadataService.CodeLocation[] soslInfo;
        public String type_x;
        private String[] dmlInfo_type_info = new String[]{'dmlInfo','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] locationsNotCovered_type_info = new String[]{'locationsNotCovered','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] methodInfo_type_info = new String[]{'methodInfo','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] namespace_type_info = new String[]{'namespace','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] numLocations_type_info = new String[]{'numLocations','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numLocationsNotCovered_type_info = new String[]{'numLocationsNotCovered','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] soqlInfo_type_info = new String[]{'soqlInfo','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] soslInfo_type_info = new String[]{'soslInfo','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dmlInfo','id','locationsNotCovered','methodInfo','name','namespace','numLocations','numLocationsNotCovered','soqlInfo','soslInfo','type_x'};
    }
    public with sharing class renameMetadata_element {
        public String type_x;
        public String oldFullName;
        public String newFullName;
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] oldFullName_type_info = new String[]{'oldFullName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] newFullName_type_info = new String[]{'newFullName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','oldFullName','newFullName'};
    }
    public with sharing class NetworkAccess {
        public MetadataService.IpRange[] ipRanges;
        private String[] ipRanges_type_info = new String[]{'ipRanges','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'ipRanges'};
    }
    public with sharing class RecordTypePicklistValue {
        public String picklist;
        public MetadataService.PicklistValue[] values;
        private String[] picklist_type_info = new String[]{'picklist','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] values_type_info = new String[]{'values','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'picklist','values'};
    }
    public with sharing class describeMetadata_element {
        public Double asOfVersion;
        private String[] asOfVersion_type_info = new String[]{'asOfVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'asOfVersion'};
    }
    public with sharing class DashboardFilterColumn {
        public String column;
        private String[] column_type_info = new String[]{'column','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'column'};
    }
    public with sharing class Territory2RuleAssociation {
        public Boolean inherited;
        public String ruleName;
        private String[] inherited_type_info = new String[]{'inherited','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] ruleName_type_info = new String[]{'ruleName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'inherited','ruleName'};
    }
    public with sharing class ReportParam {
        public String name;
        public String value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class RoleOrTerritory extends Metadata {
        public String type = 'RoleOrTerritory';
        public String fullName;
        public String caseAccessLevel;
        public String contactAccessLevel;
        public String description;
        public Boolean mayForecastManagerShare;
        public String name;
        public String opportunityAccessLevel;
        private String[] caseAccessLevel_type_info = new String[]{'caseAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] contactAccessLevel_type_info = new String[]{'contactAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mayForecastManagerShare_type_info = new String[]{'mayForecastManagerShare','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] opportunityAccessLevel_type_info = new String[]{'opportunityAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'caseAccessLevel','contactAccessLevel','description','mayForecastManagerShare','name','opportunityAccessLevel'};
    }
    public with sharing class ForecastingTypeSettings {
        public Boolean active;
        public MetadataService.AdjustmentsSettings adjustmentsSettings;
        public MetadataService.ForecastRangeSettings forecastRangeSettings;
        public String name;
        public MetadataService.OpportunityListFieldsSelectedSettings opportunityListFieldsSelectedSettings;
        public MetadataService.QuotasSettings quotasSettings;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] adjustmentsSettings_type_info = new String[]{'adjustmentsSettings','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] forecastRangeSettings_type_info = new String[]{'forecastRangeSettings','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] opportunityListFieldsSelectedSettings_type_info = new String[]{'opportunityListFieldsSelectedSettings','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] quotasSettings_type_info = new String[]{'quotasSettings','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'active','adjustmentsSettings','forecastRangeSettings','name','opportunityListFieldsSelectedSettings','quotasSettings'};
    }
    public with sharing class FlowApexPluginCallInputParameter {
        public String name;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class WorkflowActionReference {
        public String name;
        public String type_x;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','type_x'};
    }
    public with sharing class Role {
        public String parentRole;
        private String[] parentRole_type_info = new String[]{'parentRole','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'parentRole'};
    }
    public with sharing class RetrieveResult {
        public Boolean done;
        public String errorMessage;
        public String errorStatusCode;
        public MetadataService.FileProperties[] fileProperties;
        public String id;
        public MetadataService.RetrieveMessage[] messages;
        public String status;
        public Boolean success;
        public String zipFile;
        private String[] done_type_info = new String[]{'done','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] errorStatusCode_type_info = new String[]{'errorStatusCode','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fileProperties_type_info = new String[]{'fileProperties','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] messages_type_info = new String[]{'messages','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] status_type_info = new String[]{'status','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] zipFile_type_info = new String[]{'zipFile','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'done','errorMessage','errorStatusCode','fileProperties','id','messages','status','success','zipFile'};
    }
    public with sharing class CustomObjectSharingRules {
        public MetadataService.CustomObjectCriteriaBasedSharingRule[] criteriaBasedRules;
        public MetadataService.CustomObjectOwnerSharingRule[] ownerRules;
        private String[] criteriaBasedRules_type_info = new String[]{'criteriaBasedRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] ownerRules_type_info = new String[]{'ownerRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaBasedRules','ownerRules'};
    }
    public with sharing class QuickActionList {
        public MetadataService.QuickActionListItem[] quickActionListItems;
        private String[] quickActionListItems_type_info = new String[]{'quickActionListItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'quickActionListItems'};
    }
    public with sharing class RelatedList {
        public Boolean hideOnDetail;
        public String name;
        private String[] hideOnDetail_type_info = new String[]{'hideOnDetail','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'hideOnDetail','name'};
    }
    public with sharing class FlowActionCallOutputParameter {
        public String assignToReference;
        public String name;
        private String[] assignToReference_type_info = new String[]{'assignToReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','name'};
    }
    public with sharing class DashboardFilterOption {
        public String operator;
        public String[] values;
        private String[] operator_type_info = new String[]{'operator','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] values_type_info = new String[]{'values','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'operator','values'};
    }
    public with sharing class WorkflowOutboundMessage extends WorkflowAction {
        public String type = 'WorkflowOutboundMessage';
        public String fullName;
        public Double apiVersion;
        public String description;
        public String endpointUrl;
        public String[] fields;
        public Boolean includeSessionId;
        public String integrationUser;
        public String name;
        public Boolean protected_x;
        public Boolean useDeadLetterQueue;
        private String[] apiVersion_type_info = new String[]{'apiVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] endpointUrl_type_info = new String[]{'endpointUrl','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] includeSessionId_type_info = new String[]{'includeSessionId','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] integrationUser_type_info = new String[]{'integrationUser','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] useDeadLetterQueue_type_info = new String[]{'useDeadLetterQueue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'apiVersion','description','endpointUrl','fields','includeSessionId','integrationUser','name','protected_x','useDeadLetterQueue'};
    }
    public with sharing class RunTestSuccess {
        public String id;
        public String methodName;
        public String name;
        public String namespace;
        public Double time_x;
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] methodName_type_info = new String[]{'methodName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] namespace_type_info = new String[]{'namespace','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] time_x_type_info = new String[]{'time','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'id','methodName','name','namespace','time_x'};
    }
    public with sharing class LiveChatButtonDeployments {
        public String[] deployment;
        private String[] deployment_type_info = new String[]{'deployment','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'deployment'};
    }
    public with sharing class PermissionSetApplicationVisibility {
        public String application;
        public Boolean visible;
        private String[] application_type_info = new String[]{'application','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visible_type_info = new String[]{'visible','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'application','visible'};
    }
    public with sharing class InstalledPackage extends Metadata {
        public String type = 'InstalledPackage';
        public String fullName;
        public String password;
        public String versionNumber;
        private String[] password_type_info = new String[]{'password','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] versionNumber_type_info = new String[]{'versionNumber','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'password','versionNumber'};
    }
    public with sharing class LeadSharingRules {
        public MetadataService.LeadCriteriaBasedSharingRule[] criteriaBasedRules;
        public MetadataService.LeadOwnerSharingRule[] ownerRules;
        private String[] criteriaBasedRules_type_info = new String[]{'criteriaBasedRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] ownerRules_type_info = new String[]{'ownerRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaBasedRules','ownerRules'};
    }
    public with sharing class Queue extends Metadata {
        public String type = 'Queue';
        public String fullName;
        public Boolean doesSendEmailToMembers;
        public String email;
        public String name;
        public MetadataService.QueueSobject[] queueSobject;
        private String[] doesSendEmailToMembers_type_info = new String[]{'doesSendEmailToMembers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] email_type_info = new String[]{'email','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] queueSobject_type_info = new String[]{'queueSobject','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'doesSendEmailToMembers','email','name','queueSobject'};
    }
    public with sharing class ListViewFilter {
        public String field;
        public String operation;
        public String value;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] operation_type_info = new String[]{'operation','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','operation','value'};
    }
    public with sharing class CampaignOwnerSharingRule {
        public String campaignAccessLevel;
        public String description;
        public String name;
        private String[] campaignAccessLevel_type_info = new String[]{'campaignAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'campaignAccessLevel','description','name'};
    }
    public with sharing class FeedLayout {
        public Boolean autocollapsePublisher;
        public Boolean compactFeed;
        public String feedFilterPosition;
        public MetadataService.FeedLayoutFilter[] feedFilters;
        public Boolean fullWidthFeed;
        public Boolean hideSidebar;
        public MetadataService.FeedLayoutComponent[] leftComponents;
        public MetadataService.FeedLayoutComponent[] rightComponents;
        private String[] autocollapsePublisher_type_info = new String[]{'autocollapsePublisher','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] compactFeed_type_info = new String[]{'compactFeed','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] feedFilterPosition_type_info = new String[]{'feedFilterPosition','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] feedFilters_type_info = new String[]{'feedFilters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fullWidthFeed_type_info = new String[]{'fullWidthFeed','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hideSidebar_type_info = new String[]{'hideSidebar','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] leftComponents_type_info = new String[]{'leftComponents','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] rightComponents_type_info = new String[]{'rightComponents','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'autocollapsePublisher','compactFeed','feedFilterPosition','feedFilters','fullWidthFeed','hideSidebar','leftComponents','rightComponents'};
    }
    public with sharing class CustomField extends Metadata {
        public String type = 'CustomField';
        public String fullName;
        public Boolean caseSensitive;
        public String customDataType;
        public String defaultValue;
        public String deleteConstraint;
        public Boolean deprecated;
        public String description;
        public String displayFormat;
        public Boolean escapeMarkup;
        public String externalDeveloperName;
        public Boolean externalId;
        public String formula;
        public String formulaTreatBlanksAs;
        public String inlineHelpText;
        public Boolean isFilteringDisabled;
        public Boolean isNameField;
        public Boolean isSortingDisabled;
        public String label;
        public Integer length;
        public MetadataService.LookupFilter lookupFilter;
        public String maskChar;
        public String maskType;
        public MetadataService.Picklist picklist;
        public Boolean populateExistingRows;
        public Integer precision;
        public String referenceTargetField;
        public String referenceTo;
        public String relationshipLabel;
        public String relationshipName;
        public Integer relationshipOrder;
        public Boolean reparentableMasterDetail;
        public Boolean required;
        public Boolean restrictedAdminField;
        public Integer scale;
        public Integer startingNumber;
        public Boolean stripMarkup;
        public String summarizedField;
        public MetadataService.FilterItem[] summaryFilterItems;
        public String summaryForeignKey;
        public String summaryOperation;
        public Boolean trackFeedHistory;
        public Boolean trackHistory;
        public Boolean trackTrending;
        public String type_x;
        public Boolean unique;
        public Integer visibleLines;
        public Boolean writeRequiresMasterRead;
        private String[] caseSensitive_type_info = new String[]{'caseSensitive','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customDataType_type_info = new String[]{'customDataType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultValue_type_info = new String[]{'defaultValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] deleteConstraint_type_info = new String[]{'deleteConstraint','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] deprecated_type_info = new String[]{'deprecated','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayFormat_type_info = new String[]{'displayFormat','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] escapeMarkup_type_info = new String[]{'escapeMarkup','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalDeveloperName_type_info = new String[]{'externalDeveloperName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalId_type_info = new String[]{'externalId','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] formula_type_info = new String[]{'formula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] formulaTreatBlanksAs_type_info = new String[]{'formulaTreatBlanksAs','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inlineHelpText_type_info = new String[]{'inlineHelpText','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isFilteringDisabled_type_info = new String[]{'isFilteringDisabled','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isNameField_type_info = new String[]{'isNameField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isSortingDisabled_type_info = new String[]{'isSortingDisabled','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] length_type_info = new String[]{'length','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lookupFilter_type_info = new String[]{'lookupFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] maskChar_type_info = new String[]{'maskChar','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] maskType_type_info = new String[]{'maskType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] picklist_type_info = new String[]{'picklist','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] populateExistingRows_type_info = new String[]{'populateExistingRows','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] precision_type_info = new String[]{'precision','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] referenceTargetField_type_info = new String[]{'referenceTargetField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] referenceTo_type_info = new String[]{'referenceTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relationshipLabel_type_info = new String[]{'relationshipLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relationshipName_type_info = new String[]{'relationshipName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relationshipOrder_type_info = new String[]{'relationshipOrder','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reparentableMasterDetail_type_info = new String[]{'reparentableMasterDetail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] required_type_info = new String[]{'required','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] restrictedAdminField_type_info = new String[]{'restrictedAdminField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scale_type_info = new String[]{'scale','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] startingNumber_type_info = new String[]{'startingNumber','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] stripMarkup_type_info = new String[]{'stripMarkup','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summarizedField_type_info = new String[]{'summarizedField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryFilterItems_type_info = new String[]{'summaryFilterItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] summaryForeignKey_type_info = new String[]{'summaryForeignKey','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryOperation_type_info = new String[]{'summaryOperation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] trackFeedHistory_type_info = new String[]{'trackFeedHistory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] trackHistory_type_info = new String[]{'trackHistory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] trackTrending_type_info = new String[]{'trackTrending','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] unique_type_info = new String[]{'unique','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] visibleLines_type_info = new String[]{'visibleLines','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] writeRequiresMasterRead_type_info = new String[]{'writeRequiresMasterRead','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'caseSensitive','customDataType','defaultValue','deleteConstraint','deprecated','description','displayFormat','escapeMarkup','externalDeveloperName','externalId','formula','formulaTreatBlanksAs','inlineHelpText','isFilteringDisabled','isNameField','isSortingDisabled','label','length','lookupFilter','maskChar','maskType','picklist','populateExistingRows','precision','referenceTargetField','referenceTo','relationshipLabel','relationshipName','relationshipOrder','reparentableMasterDetail','required','restrictedAdminField','scale','startingNumber','stripMarkup','summarizedField','summaryFilterItems','summaryForeignKey','summaryOperation','trackFeedHistory','trackHistory','trackTrending','type_x','unique','visibleLines','writeRequiresMasterRead'};
    }
    public with sharing class PushNotification {
        public String[] fieldNames;
        public String objectName;
        private String[] fieldNames_type_info = new String[]{'fieldNames','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] objectName_type_info = new String[]{'objectName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fieldNames','objectName'};
    }
    public with sharing class EmailToCaseSettings {
        public Boolean enableEmailToCase;
        public Boolean enableHtmlEmail;
        public Boolean enableOnDemandEmailToCase;
        public Boolean enableThreadIDInBody;
        public Boolean enableThreadIDInSubject;
        public Boolean notifyOwnerOnNewCaseEmail;
        public String overEmailLimitAction;
        public MetadataService.EmailToCaseRoutingAddress[] routingAddresses;
        public String unauthorizedSenderAction;
        private String[] enableEmailToCase_type_info = new String[]{'enableEmailToCase','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableHtmlEmail_type_info = new String[]{'enableHtmlEmail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableOnDemandEmailToCase_type_info = new String[]{'enableOnDemandEmailToCase','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableThreadIDInBody_type_info = new String[]{'enableThreadIDInBody','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableThreadIDInSubject_type_info = new String[]{'enableThreadIDInSubject','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyOwnerOnNewCaseEmail_type_info = new String[]{'notifyOwnerOnNewCaseEmail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] overEmailLimitAction_type_info = new String[]{'overEmailLimitAction','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] routingAddresses_type_info = new String[]{'routingAddresses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] unauthorizedSenderAction_type_info = new String[]{'unauthorizedSenderAction','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enableEmailToCase','enableHtmlEmail','enableOnDemandEmailToCase','enableThreadIDInBody','enableThreadIDInSubject','notifyOwnerOnNewCaseEmail','overEmailLimitAction','routingAddresses','unauthorizedSenderAction'};
    }
    public with sharing class deployResponse_element {
        public MetadataService.AsyncResult result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class DataCategory {
        public MetadataService.DataCategory[] dataCategory;
        public String label;
        public String name;
        private String[] dataCategory_type_info = new String[]{'dataCategory','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dataCategory','label','name'};
    }
    public with sharing class EscalationAction {
        public String assignedTo;
        public String assignedToTemplate;
        public String assignedToType;
        public Integer minutesToEscalation;
        public Boolean notifyCaseOwner;
        public String[] notifyEmail;
        public String notifyTo;
        public String notifyToTemplate;
        private String[] assignedTo_type_info = new String[]{'assignedTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assignedToTemplate_type_info = new String[]{'assignedToTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assignedToType_type_info = new String[]{'assignedToType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] minutesToEscalation_type_info = new String[]{'minutesToEscalation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyCaseOwner_type_info = new String[]{'notifyCaseOwner','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyEmail_type_info = new String[]{'notifyEmail','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] notifyTo_type_info = new String[]{'notifyTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyToTemplate_type_info = new String[]{'notifyToTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignedTo','assignedToTemplate','assignedToType','minutesToEscalation','notifyCaseOwner','notifyEmail','notifyTo','notifyToTemplate'};
    }
    public with sharing class FlowOutputFieldAssignment {
        public String assignToReference;
        public String field;
        private String[] assignToReference_type_info = new String[]{'assignToReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','field'};
    }
    public with sharing class AppMenuItem {
        public String name;
        public String type_x;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','type_x'};
    }
    public with sharing class EmailTemplate extends MetadataWithContent {
        public String type = 'EmailTemplate';
        public String fullName;
        public String content;
        public Double apiVersion;
        public String[] attachedDocuments;
        public MetadataService.Attachment[] attachments;
        public Boolean available;
        public String description;
        public String encodingKey;
        public String letterhead;
        public String name;
        public MetadataService.PackageVersion[] packageVersions;
        public String style;
        public String subject;
        public String textOnly;
        public String type_x;
        private String[] apiVersion_type_info = new String[]{'apiVersion','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] attachedDocuments_type_info = new String[]{'attachedDocuments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] attachments_type_info = new String[]{'attachments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] available_type_info = new String[]{'available','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] encodingKey_type_info = new String[]{'encodingKey','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] letterhead_type_info = new String[]{'letterhead','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] packageVersions_type_info = new String[]{'packageVersions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] style_type_info = new String[]{'style','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] subject_type_info = new String[]{'subject','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] textOnly_type_info = new String[]{'textOnly','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'apiVersion','attachedDocuments','attachments','available','description','encodingKey','letterhead','name','packageVersions','style','subject','textOnly','type_x'};
    }
    public with sharing class ObjectUsage {
        public String[] object_x;
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'object_x'};
    }
    public with sharing class AssignmentRule extends Metadata {
        public String type = 'AssignmentRule';
        public String fullName;
        public Boolean active;
        public MetadataService.RuleEntry[] ruleEntry;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] ruleEntry_type_info = new String[]{'ruleEntry','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','ruleEntry'};
    }
    public with sharing class deleteMetadataResponse_element {
        public MetadataService.DeleteResult[] result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class CustomTabTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class LiveChatAgentConfig extends Metadata {
        public String type = 'LiveChatAgentConfig';
        public String fullName;
        public MetadataService.AgentConfigAssignments assignments;
        public String autoGreeting;
        public Integer capacity;
        public Integer criticalWaitTime;
        public String customAgentName;
        public Boolean enableAgentFileTransfer;
        public Boolean enableAgentSneakPeek;
        public Boolean enableAutoAwayOnDecline;
        public Boolean enableChatMonitoring;
        public Boolean enableChatTransfer;
        public Boolean enableLogoutSound;
        public Boolean enableNotifications;
        public Boolean enableRequestSound;
        public Boolean enableSneakPeek;
        public Boolean enableWhisperMessage;
        public String label;
        public String supervisorDefaultAgentStatusFilter;
        public String supervisorDefaultButtonFilter;
        public String supervisorDefaultSkillFilter;
        public MetadataService.SupervisorAgentConfigSkills supervisorSkills;
        public MetadataService.AgentConfigButtons transferableButtons;
        public MetadataService.AgentConfigSkills transferableSkills;
        private String[] assignments_type_info = new String[]{'assignments','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] autoGreeting_type_info = new String[]{'autoGreeting','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] capacity_type_info = new String[]{'capacity','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] criticalWaitTime_type_info = new String[]{'criticalWaitTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customAgentName_type_info = new String[]{'customAgentName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableAgentFileTransfer_type_info = new String[]{'enableAgentFileTransfer','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableAgentSneakPeek_type_info = new String[]{'enableAgentSneakPeek','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableAutoAwayOnDecline_type_info = new String[]{'enableAutoAwayOnDecline','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableChatMonitoring_type_info = new String[]{'enableChatMonitoring','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableChatTransfer_type_info = new String[]{'enableChatTransfer','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableLogoutSound_type_info = new String[]{'enableLogoutSound','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableNotifications_type_info = new String[]{'enableNotifications','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableRequestSound_type_info = new String[]{'enableRequestSound','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSneakPeek_type_info = new String[]{'enableSneakPeek','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableWhisperMessage_type_info = new String[]{'enableWhisperMessage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] supervisorDefaultAgentStatusFilter_type_info = new String[]{'supervisorDefaultAgentStatusFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] supervisorDefaultButtonFilter_type_info = new String[]{'supervisorDefaultButtonFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] supervisorDefaultSkillFilter_type_info = new String[]{'supervisorDefaultSkillFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] supervisorSkills_type_info = new String[]{'supervisorSkills','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] transferableButtons_type_info = new String[]{'transferableButtons','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] transferableSkills_type_info = new String[]{'transferableSkills','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'assignments','autoGreeting','capacity','criticalWaitTime','customAgentName','enableAgentFileTransfer','enableAgentSneakPeek','enableAutoAwayOnDecline','enableChatMonitoring','enableChatTransfer','enableLogoutSound','enableNotifications','enableRequestSound','enableSneakPeek','enableWhisperMessage','label','supervisorDefaultAgentStatusFilter','supervisorDefaultButtonFilter','supervisorDefaultSkillFilter','supervisorSkills','transferableButtons','transferableSkills'};
    }
    public with sharing class AdjustmentsSettings {
        public Boolean enableAdjustments;
        private String[] enableAdjustments_type_info = new String[]{'enableAdjustments','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enableAdjustments'};
    }
    public with sharing class BusinessProcess extends Metadata {
        public String type = 'BusinessProcess';
        public String fullName;
        public String description;
        public Boolean isActive;
        public MetadataService.PicklistValue[] values;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] values_type_info = new String[]{'values','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','isActive','values'};
    }
    public with sharing class PermissionSet extends Metadata {
        public String type = 'PermissionSet';
        public String fullName;
        public MetadataService.PermissionSetApplicationVisibility[] applicationVisibilities;
        public MetadataService.PermissionSetApexClassAccess[] classAccesses;
        public MetadataService.PermissionSetCustomPermissions[] customPermissions;
        public String description;
        public MetadataService.PermissionSetExternalDataSourceAccess[] externalDataSourceAccesses;
        public MetadataService.PermissionSetFieldPermissions[] fieldPermissions;
        public String label;
        public MetadataService.PermissionSetObjectPermissions[] objectPermissions;
        public MetadataService.PermissionSetApexPageAccess[] pageAccesses;
        public MetadataService.PermissionSetRecordTypeVisibility[] recordTypeVisibilities;
        public MetadataService.PermissionSetTabSetting[] tabSettings;
        public String userLicense;
        public MetadataService.PermissionSetUserPermission[] userPermissions;
        private String[] applicationVisibilities_type_info = new String[]{'applicationVisibilities','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] classAccesses_type_info = new String[]{'classAccesses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] customPermissions_type_info = new String[]{'customPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalDataSourceAccesses_type_info = new String[]{'externalDataSourceAccesses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fieldPermissions_type_info = new String[]{'fieldPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] objectPermissions_type_info = new String[]{'objectPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] pageAccesses_type_info = new String[]{'pageAccesses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] recordTypeVisibilities_type_info = new String[]{'recordTypeVisibilities','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] tabSettings_type_info = new String[]{'tabSettings','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] userLicense_type_info = new String[]{'userLicense','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] userPermissions_type_info = new String[]{'userPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'applicationVisibilities','classAccesses','customPermissions','description','externalDataSourceAccesses','fieldPermissions','label','objectPermissions','pageAccesses','recordTypeVisibilities','tabSettings','userLicense','userPermissions'};
    }
    public with sharing class ConnectedAppAttribute {
        public String formula;
        public String key;
        private String[] formula_type_info = new String[]{'formula','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] key_type_info = new String[]{'key','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'formula','key'};
    }
    public with sharing class ManagedTopics extends Metadata {
        public String type = 'ManagedTopics';
        public String fullName;
        public MetadataService.ManagedTopic[] managedTopic;
        private String[] managedTopic_type_info = new String[]{'managedTopic','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'managedTopic'};
    }
    public with sharing class ForecastingSettings extends Metadata {
        public String type = 'ForecastingSettings';
        public String fullName;
        public String displayCurrency;
        public Boolean enableForecasts;
        public MetadataService.ForecastingTypeSettings[] forecastingTypeSettings;
        private String[] displayCurrency_type_info = new String[]{'displayCurrency','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableForecasts_type_info = new String[]{'enableForecasts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] forecastingTypeSettings_type_info = new String[]{'forecastingTypeSettings','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'displayCurrency','enableForecasts','forecastingTypeSettings'};
    }
    public with sharing class ReportChartComponentLayoutItem {
        public Boolean cacheData;
        public String contextFilterableField;
        public String error;
        public Boolean hideOnError;
        public Boolean includeContext;
        public String reportName;
        public Boolean showTitle;
        public String size;
        private String[] cacheData_type_info = new String[]{'cacheData','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] contextFilterableField_type_info = new String[]{'contextFilterableField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] error_type_info = new String[]{'error','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hideOnError_type_info = new String[]{'hideOnError','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] includeContext_type_info = new String[]{'includeContext','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reportName_type_info = new String[]{'reportName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] showTitle_type_info = new String[]{'showTitle','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] size_type_info = new String[]{'size','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'cacheData','contextFilterableField','error','hideOnError','includeContext','reportName','showTitle','size'};
    }
    public with sharing class AppMenu extends Metadata {
        public String type = 'AppMenu';
        public String fullName;
        public MetadataService.AppMenuItem[] appMenuItems;
        private String[] appMenuItems_type_info = new String[]{'appMenuItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'appMenuItems'};
    }
    public with sharing class FlowSubflowOutputAssignment {
        public String assignToReference;
        public String name;
        private String[] assignToReference_type_info = new String[]{'assignToReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','name'};
    }
    public with sharing class ContactSharingRules {
        public MetadataService.ContactCriteriaBasedSharingRule[] criteriaBasedRules;
        public MetadataService.ContactOwnerSharingRule[] ownerRules;
        private String[] criteriaBasedRules_type_info = new String[]{'criteriaBasedRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] ownerRules_type_info = new String[]{'ownerRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaBasedRules','ownerRules'};
    }
    public with sharing class AccountTerritorySharingRules {
        public MetadataService.AccountTerritorySharingRule[] rules;
        private String[] rules_type_info = new String[]{'rules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'rules'};
    }
    public with sharing class ConnectedAppIpRange {
        public String description;
        public String end_x;
        public String start;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] end_x_type_info = new String[]{'end','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] start_type_info = new String[]{'start','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','end_x','start'};
    }
    public with sharing class Package_x extends Metadata {
        public String type = 'Package_x';
        public String fullName;
        public String apiAccessLevel;
        public String description;
        public String namespacePrefix;
        public MetadataService.ProfileObjectPermissions[] objectPermissions;
        public String postInstallClass;
        public String setupWeblink;
        public MetadataService.PackageTypeMembers[] types;
        public String uninstallClass;
        public String version;
        private String[] apiAccessLevel_type_info = new String[]{'apiAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] namespacePrefix_type_info = new String[]{'namespacePrefix','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] objectPermissions_type_info = new String[]{'objectPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] postInstallClass_type_info = new String[]{'postInstallClass','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] setupWeblink_type_info = new String[]{'setupWeblink','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] types_type_info = new String[]{'types','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] uninstallClass_type_info = new String[]{'uninstallClass','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] version_type_info = new String[]{'version','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'apiAccessLevel','description','namespacePrefix','objectPermissions','postInstallClass','setupWeblink','types','uninstallClass','version'};
    }
    public with sharing class FlowActionCall {
        public String actionName;
        public String actionType;
        public MetadataService.FlowConnector connector;
        public MetadataService.FlowConnector faultConnector;
        public MetadataService.FlowActionCallInputParameter[] inputParameters;
        public MetadataService.FlowActionCallOutputParameter[] outputParameters;
        private String[] actionName_type_info = new String[]{'actionName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] actionType_type_info = new String[]{'actionType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] faultConnector_type_info = new String[]{'faultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inputParameters_type_info = new String[]{'inputParameters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] outputParameters_type_info = new String[]{'outputParameters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'actionName','actionType','connector','faultConnector','inputParameters','outputParameters'};
    }
    public virtual class MetadataWithContent extends Metadata {
        public String content;
        private String[] content_type_info = new String[]{'content','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'content'};
    }
    public with sharing class RetrieveRequest {
        public Double apiVersion;
        public String[] packageNames;
        public Boolean singlePackage;
        public String[] specificFiles;
        public MetadataService.Package_x unpackaged;
        private String[] apiVersion_type_info = new String[]{'apiVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] packageNames_type_info = new String[]{'packageNames','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] singlePackage_type_info = new String[]{'singlePackage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] specificFiles_type_info = new String[]{'specificFiles','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] unpackaged_type_info = new String[]{'unpackaged','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apiVersion','packageNames','singlePackage','specificFiles','unpackaged'};
    }
    public with sharing class ListMetadataQuery {
        public String folder;
        public String type_x;
        private String[] folder_type_info = new String[]{'folder','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'folder','type_x'};
    }
    public with sharing class FlowConnector {
        public String targetReference;
        private String[] targetReference_type_info = new String[]{'targetReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'targetReference'};
    }
    public with sharing class CustomApplicationComponent extends Metadata {
        public String type = 'CustomApplicationComponent';
        public String fullName;
        public String buttonIconUrl;
        public String buttonStyle;
        public String buttonText;
        public Integer buttonWidth;
        public Integer height;
        public Boolean isHeightFixed;
        public Boolean isHidden;
        public Boolean isWidthFixed;
        public String visualforcePage;
        public Integer width;
        private String[] buttonIconUrl_type_info = new String[]{'buttonIconUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] buttonStyle_type_info = new String[]{'buttonStyle','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] buttonText_type_info = new String[]{'buttonText','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] buttonWidth_type_info = new String[]{'buttonWidth','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isHeightFixed_type_info = new String[]{'isHeightFixed','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isHidden_type_info = new String[]{'isHidden','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isWidthFixed_type_info = new String[]{'isWidthFixed','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visualforcePage_type_info = new String[]{'visualforcePage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'buttonIconUrl','buttonStyle','buttonText','buttonWidth','height','isHeightFixed','isHidden','isWidthFixed','visualforcePage','width'};
    }
    public with sharing class FlowRecordLookup {
        public Boolean assignNullValuesIfNoRecordsFound;
        public MetadataService.FlowConnector connector;
        public MetadataService.FlowConnector faultConnector;
        public MetadataService.FlowRecordFilter[] filters;
        public String object_x;
        public MetadataService.FlowOutputFieldAssignment[] outputAssignments;
        public String outputReference;
        public String[] queriedFields;
        public String sortField;
        public String sortOrder;
        private String[] assignNullValuesIfNoRecordsFound_type_info = new String[]{'assignNullValuesIfNoRecordsFound','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] faultConnector_type_info = new String[]{'faultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] filters_type_info = new String[]{'filters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] outputAssignments_type_info = new String[]{'outputAssignments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] outputReference_type_info = new String[]{'outputReference','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] queriedFields_type_info = new String[]{'queriedFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] sortField_type_info = new String[]{'sortField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortOrder_type_info = new String[]{'sortOrder','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignNullValuesIfNoRecordsFound','connector','faultConnector','filters','object_x','outputAssignments','outputReference','queriedFields','sortField','sortOrder'};
    }
    public with sharing class FieldSet extends Metadata {
        public String type = 'FieldSet';
        public String fullName;
        public MetadataService.FieldSetItem[] availableFields;
        public String description;
        public MetadataService.FieldSetItem[] displayedFields;
        public String label;
        public String id;
        private String[] availableFields_type_info = new String[]{'availableFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] displayedFields_type_info = new String[]{'displayedFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fieldSetId = new String[]{'id', 'https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'id','fullName', 'availableFields','description','displayedFields','label'};

    }
    public with sharing class Error {
        public String[] fields;
        public String message;
        public String statusCode;
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] message_type_info = new String[]{'message','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fields','message','statusCode'};
    }
    public with sharing class AccountCriteriaBasedSharingRule {
        public String accountAccessLevel;
        public String booleanFilter;
        public String caseAccessLevel;
        public String contactAccessLevel;
        public String description;
        public String name;
        public String opportunityAccessLevel;
        private String[] accountAccessLevel_type_info = new String[]{'accountAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseAccessLevel_type_info = new String[]{'caseAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] contactAccessLevel_type_info = new String[]{'contactAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] opportunityAccessLevel_type_info = new String[]{'opportunityAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accountAccessLevel','booleanFilter','caseAccessLevel','contactAccessLevel','description','name','opportunityAccessLevel'};
    }
    public with sharing class DebuggingHeader_element {
        public MetadataService.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }
    public with sharing class ComponentInstanceProperty {
        public String name;
        public String value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class FlowRecordDelete {
        public MetadataService.FlowConnector connector;
        public MetadataService.FlowConnector faultConnector;
        public MetadataService.FlowRecordFilter[] filters;
        public String inputReference;
        public String object_x;
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] faultConnector_type_info = new String[]{'faultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] filters_type_info = new String[]{'filters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] inputReference_type_info = new String[]{'inputReference','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'connector','faultConnector','filters','inputReference','object_x'};
    }
    public with sharing class FlowDecision {
        public MetadataService.FlowConnector defaultConnector;
        public String defaultConnectorLabel;
        public MetadataService.FlowRule[] rules;
        private String[] defaultConnector_type_info = new String[]{'defaultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultConnectorLabel_type_info = new String[]{'defaultConnectorLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] rules_type_info = new String[]{'rules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'defaultConnector','defaultConnectorLabel','rules'};
    }
    public with sharing class QuickActionListItem {
        public String quickActionName;
        private String[] quickActionName_type_info = new String[]{'quickActionName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'quickActionName'};
    }
    public with sharing class Branding {
        public String loginFooterText;
        public String loginLogo;
        public String pageFooter;
        public String pageHeader;
        public String primaryColor;
        public String primaryComplementColor;
        public String quaternaryColor;
        public String quaternaryComplementColor;
        public String secondaryColor;
        public String tertiaryColor;
        public String tertiaryComplementColor;
        public String zeronaryColor;
        public String zeronaryComplementColor;
        private String[] loginFooterText_type_info = new String[]{'loginFooterText','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] loginLogo_type_info = new String[]{'loginLogo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] pageFooter_type_info = new String[]{'pageFooter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] pageHeader_type_info = new String[]{'pageHeader','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] primaryColor_type_info = new String[]{'primaryColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] primaryComplementColor_type_info = new String[]{'primaryComplementColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] quaternaryColor_type_info = new String[]{'quaternaryColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] quaternaryComplementColor_type_info = new String[]{'quaternaryComplementColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] secondaryColor_type_info = new String[]{'secondaryColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] tertiaryColor_type_info = new String[]{'tertiaryColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] tertiaryComplementColor_type_info = new String[]{'tertiaryComplementColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] zeronaryColor_type_info = new String[]{'zeronaryColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] zeronaryComplementColor_type_info = new String[]{'zeronaryComplementColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'loginFooterText','loginLogo','pageFooter','pageHeader','primaryColor','primaryComplementColor','quaternaryColor','quaternaryComplementColor','secondaryColor','tertiaryColor','tertiaryComplementColor','zeronaryColor','zeronaryComplementColor'};
    }
    public with sharing class CustomLabel extends Metadata {
        public String type = 'CustomLabel';
        public String fullName;
        public String categories;
        public String language;
        public Boolean protected_x;
        public String shortDescription;
        public String value;
        private String[] categories_type_info = new String[]{'categories','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] language_type_info = new String[]{'language','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] shortDescription_type_info = new String[]{'shortDescription','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'categories','language','protected_x','shortDescription','value'};
    }
    public with sharing class Attachment {
        public String content;
        public String name;
        private String[] content_type_info = new String[]{'content','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'content','name'};
    }
    public with sharing class BusinessHoursEntry extends Metadata {
        public String type = 'BusinessHoursEntry';
        public String fullName;
        public Boolean active;
        public Boolean default_x;
        public DateTime fridayEndTime;
        public DateTime fridayStartTime;
        public DateTime mondayEndTime;
        public DateTime mondayStartTime;
        public String name;
        public DateTime saturdayEndTime;
        public DateTime saturdayStartTime;
        public DateTime sundayEndTime;
        public DateTime sundayStartTime;
        public DateTime thursdayEndTime;
        public DateTime thursdayStartTime;
        public String timeZoneId;
        public DateTime tuesdayEndTime;
        public DateTime tuesdayStartTime;
        public DateTime wednesdayEndTime;
        public DateTime wednesdayStartTime;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] default_x_type_info = new String[]{'default','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fridayEndTime_type_info = new String[]{'fridayEndTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fridayStartTime_type_info = new String[]{'fridayStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mondayEndTime_type_info = new String[]{'mondayEndTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mondayStartTime_type_info = new String[]{'mondayStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] saturdayEndTime_type_info = new String[]{'saturdayEndTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] saturdayStartTime_type_info = new String[]{'saturdayStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sundayEndTime_type_info = new String[]{'sundayEndTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sundayStartTime_type_info = new String[]{'sundayStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] thursdayEndTime_type_info = new String[]{'thursdayEndTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] thursdayStartTime_type_info = new String[]{'thursdayStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] timeZoneId_type_info = new String[]{'timeZoneId','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] tuesdayEndTime_type_info = new String[]{'tuesdayEndTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] tuesdayStartTime_type_info = new String[]{'tuesdayStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] wednesdayEndTime_type_info = new String[]{'wednesdayEndTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] wednesdayStartTime_type_info = new String[]{'wednesdayStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','default_x','fridayEndTime','fridayStartTime','mondayEndTime','mondayStartTime','name','saturdayEndTime','saturdayStartTime','sundayEndTime','sundayStartTime','thursdayEndTime','thursdayStartTime','timeZoneId','tuesdayEndTime','tuesdayStartTime','wednesdayEndTime','wednesdayStartTime'};
    }
    public with sharing class FiscalYearSettings {
        public String fiscalYearNameBasedOn;
        public String startMonth;
        private String[] fiscalYearNameBasedOn_type_info = new String[]{'fiscalYearNameBasedOn','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] startMonth_type_info = new String[]{'startMonth','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fiscalYearNameBasedOn','startMonth'};
    }
    public with sharing class SharingRules extends Metadata {
        public String type = 'SharingRules';
        public String fullName;
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName'};
    }
    public with sharing class ChatterAnswersSettings extends Metadata {
        public String type = 'ChatterAnswersSettings';
        public String fullName;
        public Boolean emailFollowersOnBestAnswer;
        public Boolean emailFollowersOnReply;
        public Boolean emailOwnerOnPrivateReply;
        public Boolean emailOwnerOnReply;
        public Boolean enableAnswerViaEmail;
        public Boolean enableChatterAnswers;
        public Boolean enableFacebookSSO;
        public Boolean enableInlinePublisher;
        public Boolean enableReputation;
        public Boolean enableRichTextEditor;
        public String facebookAuthProvider;
        public Boolean showInPortals;
        private String[] emailFollowersOnBestAnswer_type_info = new String[]{'emailFollowersOnBestAnswer','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailFollowersOnReply_type_info = new String[]{'emailFollowersOnReply','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailOwnerOnPrivateReply_type_info = new String[]{'emailOwnerOnPrivateReply','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailOwnerOnReply_type_info = new String[]{'emailOwnerOnReply','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableAnswerViaEmail_type_info = new String[]{'enableAnswerViaEmail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableChatterAnswers_type_info = new String[]{'enableChatterAnswers','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enableFacebookSSO_type_info = new String[]{'enableFacebookSSO','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableInlinePublisher_type_info = new String[]{'enableInlinePublisher','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableReputation_type_info = new String[]{'enableReputation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableRichTextEditor_type_info = new String[]{'enableRichTextEditor','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] facebookAuthProvider_type_info = new String[]{'facebookAuthProvider','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showInPortals_type_info = new String[]{'showInPortals','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'emailFollowersOnBestAnswer','emailFollowersOnReply','emailOwnerOnPrivateReply','emailOwnerOnReply','enableAnswerViaEmail','enableChatterAnswers','enableFacebookSSO','enableInlinePublisher','enableReputation','enableRichTextEditor','facebookAuthProvider','showInPortals'};
    }
    public with sharing class CustomConsoleComponents {
        public MetadataService.PrimaryTabComponents primaryTabComponents;
        public MetadataService.SubtabComponents subtabComponents;
        private String[] primaryTabComponents_type_info = new String[]{'primaryTabComponents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] subtabComponents_type_info = new String[]{'subtabComponents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'primaryTabComponents','subtabComponents'};
    }
    public with sharing class ChartSummary {
        public String aggregate;
        public String axisBinding;
        public String column;
        private String[] aggregate_type_info = new String[]{'aggregate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] axisBinding_type_info = new String[]{'axisBinding','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] column_type_info = new String[]{'column','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'aggregate','axisBinding','column'};
    }
    public with sharing class QuickActionLayoutItem {
        public Boolean emptySpace;
        public String field;
        public String uiBehavior;
        private String[] emptySpace_type_info = new String[]{'emptySpace','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] uiBehavior_type_info = new String[]{'uiBehavior','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'emptySpace','field','uiBehavior'};
    }
    public with sharing class Picklist {
        public String controllingField;
        public MetadataService.PicklistValue[] picklistValues;
        public Boolean sorted;
        private String[] controllingField_type_info = new String[]{'controllingField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] sorted_type_info = new String[]{'sorted','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'controllingField','picklistValues','sorted'};
    }
    public with sharing class ReportLayoutSection {
        public MetadataService.ReportTypeColumn[] columns;
        public String masterLabel;
        private String[] columns_type_info = new String[]{'columns','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'columns','masterLabel'};
    }
    public with sharing class SummaryLayoutItem {
        public String customLink;
        public String field;
        public Integer posX;
        public Integer posY;
        public Integer posZ;
        private String[] customLink_type_info = new String[]{'customLink','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] posX_type_info = new String[]{'posX','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] posY_type_info = new String[]{'posY','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] posZ_type_info = new String[]{'posZ','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'customLink','field','posX','posY','posZ'};
    }
    public with sharing class LayoutSection {
        public Boolean customLabel;
        public Boolean detailHeading;
        public Boolean editHeading;
        public String label;
        public MetadataService.LayoutColumn[] layoutColumns;
        public String style;
        private String[] customLabel_type_info = new String[]{'customLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] detailHeading_type_info = new String[]{'detailHeading','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] editHeading_type_info = new String[]{'editHeading','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] layoutColumns_type_info = new String[]{'layoutColumns','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] style_type_info = new String[]{'style','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'customLabel','detailHeading','editHeading','label','layoutColumns','style'};
    }
    public with sharing class CountriesAndStates {
        public MetadataService.Country[] countries;
        private String[] countries_type_info = new String[]{'countries','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'countries'};
    }
    public with sharing class OpportunityListFieldsSelectedSettings {
        public String[] field;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field'};
    }
    public with sharing class ReportTimeFrameFilter {
        public String dateColumn;
        public Date endDate;
        public String interval;
        public Date startDate;
        private String[] dateColumn_type_info = new String[]{'dateColumn','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] endDate_type_info = new String[]{'endDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] interval_type_info = new String[]{'interval','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dateColumn','endDate','interval','startDate'};
    }
    public with sharing class XOrgHub extends Metadata {
        public String type = 'XOrgHub';
        public String fullName;
        public String label;
        public Boolean lockSharedObjects;
        public String[] permissionSets;
        public MetadataService.XOrgHubSharedObject[] sharedObjects;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lockSharedObjects_type_info = new String[]{'lockSharedObjects','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] permissionSets_type_info = new String[]{'permissionSets','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] sharedObjects_type_info = new String[]{'sharedObjects','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'label','lockSharedObjects','permissionSets','sharedObjects'};
    }
    public with sharing class ApprovalStepRejectBehavior {
        public String type_x;
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'type_x'};
    }
    public with sharing class EmailToCaseRoutingAddress {
        public String addressType;
        public String authorizedSenders;
        public String caseOrigin;
        public String caseOwner;
        public String caseOwnerType;
        public String casePriority;
        public Boolean createTask;
        public String emailAddress;
        public String routingName;
        public Boolean saveEmailHeaders;
        public String taskStatus;
        private String[] addressType_type_info = new String[]{'addressType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] authorizedSenders_type_info = new String[]{'authorizedSenders','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseOrigin_type_info = new String[]{'caseOrigin','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseOwner_type_info = new String[]{'caseOwner','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseOwnerType_type_info = new String[]{'caseOwnerType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] casePriority_type_info = new String[]{'casePriority','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] createTask_type_info = new String[]{'createTask','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailAddress_type_info = new String[]{'emailAddress','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] routingName_type_info = new String[]{'routingName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] saveEmailHeaders_type_info = new String[]{'saveEmailHeaders','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] taskStatus_type_info = new String[]{'taskStatus','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'addressType','authorizedSenders','caseOrigin','caseOwner','caseOwnerType','casePriority','createTask','emailAddress','routingName','saveEmailHeaders','taskStatus'};
    }
    public with sharing class FlowWaitEventInputParameter {
        public String name;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class FolderShare {
        public String accessLevel;
        public String sharedTo;
        public String sharedToType;
        private String[] accessLevel_type_info = new String[]{'accessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sharedTo_type_info = new String[]{'sharedTo','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sharedToType_type_info = new String[]{'sharedToType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accessLevel','sharedTo','sharedToType'};
    }
    public with sharing class ManagedTopic {
        public String managedTopicType;
        public String name;
        public Integer position;
        public String topicDescription;
        private String[] managedTopicType_type_info = new String[]{'managedTopicType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] position_type_info = new String[]{'position','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] topicDescription_type_info = new String[]{'topicDescription','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'managedTopicType','name','position','topicDescription'};
    }
    public with sharing class ApprovalEntryCriteria {
        public String booleanFilter;
        public MetadataService.FilterItem[] criteriaItems;
        public String formula;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] criteriaItems_type_info = new String[]{'criteriaItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] formula_type_info = new String[]{'formula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanFilter','criteriaItems','formula'};
    }
    public with sharing class Territory2RuleItem {
        public String field;
        public String operation;
        public String value;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] operation_type_info = new String[]{'operation','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','operation','value'};
    }
    public with sharing class WorkspaceMapping {
        public String fieldName;
        public String tab;
        private String[] fieldName_type_info = new String[]{'fieldName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] tab_type_info = new String[]{'tab','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fieldName','tab'};
    }
    public with sharing class ApexPage extends MetadataWithContent {
        public String type = 'ApexPage';
        public String fullName;
        public String content;
        public Double apiVersion;
        public Boolean availableInTouch;
        public Boolean confirmationTokenRequired;
        public String description;
        public String label;
        public MetadataService.PackageVersion[] packageVersions;
        private String[] apiVersion_type_info = new String[]{'apiVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] availableInTouch_type_info = new String[]{'availableInTouch','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] confirmationTokenRequired_type_info = new String[]{'confirmationTokenRequired','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] packageVersions_type_info = new String[]{'packageVersions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'apiVersion','availableInTouch','confirmationTokenRequired','description','label','packageVersions'};
    }
    public with sharing class ProductSettings extends Metadata {
        public String type = 'ProductSettings';
        public String fullName;
        public Boolean enableCascadeActivateToRelatedPrices;
        public Boolean enableQuantitySchedule;
        public Boolean enableRevenueSchedule;
        private String[] enableCascadeActivateToRelatedPrices_type_info = new String[]{'enableCascadeActivateToRelatedPrices','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableQuantitySchedule_type_info = new String[]{'enableQuantitySchedule','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableRevenueSchedule_type_info = new String[]{'enableRevenueSchedule','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'enableCascadeActivateToRelatedPrices','enableQuantitySchedule','enableRevenueSchedule'};
    }
    public with sharing class OpportunitySettings extends Metadata {
        public String type = 'OpportunitySettings';
        public String fullName;
        public Boolean autoActivateNewReminders;
        public Boolean enableFindSimilarOpportunities;
        public Boolean enableOpportunityTeam;
        public Boolean enableUpdateReminders;
        public MetadataService.FindSimilarOppFilter findSimilarOppFilter;
        public Boolean promptToAddProducts;
        private String[] autoActivateNewReminders_type_info = new String[]{'autoActivateNewReminders','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableFindSimilarOpportunities_type_info = new String[]{'enableFindSimilarOpportunities','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableOpportunityTeam_type_info = new String[]{'enableOpportunityTeam','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableUpdateReminders_type_info = new String[]{'enableUpdateReminders','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] findSimilarOppFilter_type_info = new String[]{'findSimilarOppFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] promptToAddProducts_type_info = new String[]{'promptToAddProducts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'autoActivateNewReminders','enableFindSimilarOpportunities','enableOpportunityTeam','enableUpdateReminders','findSimilarOppFilter','promptToAddProducts'};
    }
    public with sharing class LiveChatDeployment extends Metadata {
        public String type = 'LiveChatDeployment';
        public String fullName;
        public String brandingImage;
        public Boolean displayQueuePosition;
        public MetadataService.LiveChatDeploymentDomainWhitelist domainWhiteList;
        public Boolean enablePrechatApi;
        public Boolean enableTranscriptSave;
        public String label;
        public String mobileBrandingImage;
        public String site;
        public String windowTitle;
        private String[] brandingImage_type_info = new String[]{'brandingImage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayQueuePosition_type_info = new String[]{'displayQueuePosition','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] domainWhiteList_type_info = new String[]{'domainWhiteList','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enablePrechatApi_type_info = new String[]{'enablePrechatApi','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableTranscriptSave_type_info = new String[]{'enableTranscriptSave','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] mobileBrandingImage_type_info = new String[]{'mobileBrandingImage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] site_type_info = new String[]{'site','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] windowTitle_type_info = new String[]{'windowTitle','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'brandingImage','displayQueuePosition','domainWhiteList','enablePrechatApi','enableTranscriptSave','label','mobileBrandingImage','site','windowTitle'};
    }
    public with sharing class RelatedContent {
        public MetadataService.RelatedContentItem[] relatedContentItems;
        private String[] relatedContentItems_type_info = new String[]{'relatedContentItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'relatedContentItems'};
    }
    public with sharing class SupervisorAgentConfigSkills {
        public String[] skill;
        private String[] skill_type_info = new String[]{'skill','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'skill'};
    }
    public with sharing class QuickActionLayoutColumn {
        public MetadataService.QuickActionLayoutItem[] quickActionLayoutItems;
        private String[] quickActionLayoutItems_type_info = new String[]{'quickActionLayoutItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'quickActionLayoutItems'};
    }
    public with sharing class CustomPermission extends Metadata {
        public String type = 'CustomPermission';
        public String fullName;
        public String connectedApp;
        public String description;
        public String label;
        public MetadataService.CustomPermissionDependencyRequired[] requiredPermission;
        private String[] connectedApp_type_info = new String[]{'connectedApp','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] requiredPermission_type_info = new String[]{'requiredPermission','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'connectedApp','description','label','requiredPermission'};
    }
    public with sharing class AccountTerritorySharingRule {
        public String accountAccessLevel;
        public String caseAccessLevel;
        public String contactAccessLevel;
        public String description;
        public String name;
        public String opportunityAccessLevel;
        private String[] accountAccessLevel_type_info = new String[]{'accountAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] caseAccessLevel_type_info = new String[]{'caseAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] contactAccessLevel_type_info = new String[]{'contactAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] opportunityAccessLevel_type_info = new String[]{'opportunityAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accountAccessLevel','caseAccessLevel','contactAccessLevel','description','name','opportunityAccessLevel'};
    }
    public with sharing class DataPipeline {
        public Double apiVersion;
        public String label;
        public String scriptType;
        private String[] apiVersion_type_info = new String[]{'apiVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] scriptType_type_info = new String[]{'scriptType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apiVersion','label','scriptType'};
    }
    public with sharing class CompanySettings extends Metadata {
        public String type = 'CompanySettings';
        public String fullName;
        public MetadataService.FiscalYearSettings fiscalYear;
        private String[] fiscalYear_type_info = new String[]{'fiscalYear','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'fiscalYear'};
    }
    public with sharing class OpportunitySharingRules {
        public MetadataService.OpportunityCriteriaBasedSharingRule[] criteriaBasedRules;
        public MetadataService.OpportunityOwnerSharingRule[] ownerRules;
        private String[] criteriaBasedRules_type_info = new String[]{'criteriaBasedRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] ownerRules_type_info = new String[]{'ownerRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaBasedRules','ownerRules'};
    }
    public with sharing class HomePageLayout extends Metadata {
        public String type = 'HomePageLayout';
        public String fullName;
        public String[] narrowComponents;
        public String[] wideComponents;
        private String[] narrowComponents_type_info = new String[]{'narrowComponents','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] wideComponents_type_info = new String[]{'wideComponents','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'narrowComponents','wideComponents'};
    }
    public with sharing class UiPlugin {
        public String description;
        public String extensionPointIdentifier;
        public Boolean isEnabled;
        public String language;
        public String masterLabel;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] extensionPointIdentifier_type_info = new String[]{'extensionPointIdentifier','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isEnabled_type_info = new String[]{'isEnabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] language_type_info = new String[]{'language','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','extensionPointIdentifier','isEnabled','language','masterLabel'};
    }
    public with sharing class SiteWebAddress {
        public String certificate;
        public String domainName;
        public Boolean primary;
        private String[] certificate_type_info = new String[]{'certificate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] domainName_type_info = new String[]{'domainName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] primary_type_info = new String[]{'primary','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'certificate','domainName','primary'};
    }
    public with sharing class RetrieveMessage {
        public String fileName;
        public String problem;
        private String[] fileName_type_info = new String[]{'fileName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] problem_type_info = new String[]{'problem','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fileName','problem'};
    }
    public with sharing class AssignmentRules extends Metadata {
        public String type = 'AssignmentRules';
        public String fullName;
        public MetadataService.AssignmentRule[] assignmentRule;
        private String[] assignmentRule_type_info = new String[]{'assignmentRule','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'assignmentRule'};
    }
    public with sharing class EmailFolder extends Folder {
        public String type = 'EmailFolder';
        public String fullName;
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName'};
    }
    public with sharing class Territory2Rule {
        public Boolean active;
        public String booleanFilter;
        public String name;
        public String objectType;
        public MetadataService.Territory2RuleItem[] ruleItems;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] objectType_type_info = new String[]{'objectType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] ruleItems_type_info = new String[]{'ruleItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'active','booleanFilter','name','objectType','ruleItems'};
    }
    public with sharing class ComponentInstance {
        public MetadataService.ComponentInstanceProperty[] componentInstanceProperties;
        public String componentName;
        private String[] componentInstanceProperties_type_info = new String[]{'componentInstanceProperties','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] componentName_type_info = new String[]{'componentName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'componentInstanceProperties','componentName'};
    }
    public with sharing class WebToCaseSettings {
        public String caseOrigin;
        public String defaultResponseTemplate;
        public Boolean enableWebToCase;
        private String[] caseOrigin_type_info = new String[]{'caseOrigin','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultResponseTemplate_type_info = new String[]{'defaultResponseTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableWebToCase_type_info = new String[]{'enableWebToCase','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'caseOrigin','defaultResponseTemplate','enableWebToCase'};
    }
    public with sharing class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public with sharing class EscalationRule extends Metadata {
        public String type = 'EscalationRule';
        public String fullName;
        public Boolean active;
        public MetadataService.RuleEntry[] ruleEntry;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] ruleEntry_type_info = new String[]{'ruleEntry','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','ruleEntry'};
    }
    public with sharing class SidebarComponent {
        public String componentType;
        public Integer height;
        public String label;
        public String lookup;
        public String page_x;
        public MetadataService.RelatedList[] relatedLists;
        public String unit;
        public Integer width;
        private String[] componentType_type_info = new String[]{'componentType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lookup_type_info = new String[]{'lookup','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relatedLists_type_info = new String[]{'relatedLists','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] unit_type_info = new String[]{'unit','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'componentType','height','label','lookup','page_x','relatedLists','unit','width'};
    }
    public with sharing class SummaryLayout {
        public String masterLabel;
        public Integer sizeX;
        public Integer sizeY;
        public Integer sizeZ;
        public MetadataService.SummaryLayoutItem[] summaryLayoutItems;
        public String summaryLayoutStyle;
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sizeX_type_info = new String[]{'sizeX','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sizeY_type_info = new String[]{'sizeY','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sizeZ_type_info = new String[]{'sizeZ','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryLayoutItems_type_info = new String[]{'summaryLayoutItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] summaryLayoutStyle_type_info = new String[]{'summaryLayoutStyle','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'masterLabel','sizeX','sizeY','sizeZ','summaryLayoutItems','summaryLayoutStyle'};
    }
    public with sharing class FlowCondition {
        public String leftValueReference;
        public String operator;
        public MetadataService.FlowElementReferenceOrValue rightValue;
        private String[] leftValueReference_type_info = new String[]{'leftValueReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] rightValue_type_info = new String[]{'rightValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'leftValueReference','operator','rightValue'};
    }
    public with sharing class DeployOptions {
        public Boolean allowMissingFiles;
        public Boolean autoUpdatePackage;
        public Boolean checkOnly;
        public Boolean ignoreWarnings;
        public Boolean performRetrieve;
        public Boolean purgeOnDelete;
        public Boolean rollbackOnError;
        public Boolean runAllTests;
        public String[] runTests;
        public Boolean singlePackage;
        private String[] allowMissingFiles_type_info = new String[]{'allowMissingFiles','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] autoUpdatePackage_type_info = new String[]{'autoUpdatePackage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] checkOnly_type_info = new String[]{'checkOnly','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] ignoreWarnings_type_info = new String[]{'ignoreWarnings','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] performRetrieve_type_info = new String[]{'performRetrieve','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] purgeOnDelete_type_info = new String[]{'purgeOnDelete','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] rollbackOnError_type_info = new String[]{'rollbackOnError','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] runAllTests_type_info = new String[]{'runAllTests','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] runTests_type_info = new String[]{'runTests','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] singlePackage_type_info = new String[]{'singlePackage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'allowMissingFiles','autoUpdatePackage','checkOnly','ignoreWarnings','performRetrieve','purgeOnDelete','rollbackOnError','runAllTests','runTests','singlePackage'};
    }
    public with sharing class ProfileApplicationVisibility {
        public String application;
        public Boolean default_x;
        public Boolean visible;
        private String[] application_type_info = new String[]{'application','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] default_x_type_info = new String[]{'default','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visible_type_info = new String[]{'visible','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'application','default_x','visible'};
    }
    public with sharing class Holiday {
        public Date activityDate;
        public String[] businessHours;
        public String description;
        public DateTime endTime;
        public Boolean isRecurring;
        public String name;
        public Integer recurrenceDayOfMonth;
        public String[] recurrenceDayOfWeek;
        public Integer recurrenceDayOfWeekMask;
        public Date recurrenceEndDate;
        public String recurrenceInstance;
        public Integer recurrenceInterval;
        public String recurrenceMonthOfYear;
        public Date recurrenceStartDate;
        public String recurrenceType;
        public DateTime startTime;
        private String[] activityDate_type_info = new String[]{'activityDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] businessHours_type_info = new String[]{'businessHours','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] endTime_type_info = new String[]{'endTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isRecurring_type_info = new String[]{'isRecurring','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceDayOfMonth_type_info = new String[]{'recurrenceDayOfMonth','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceDayOfWeek_type_info = new String[]{'recurrenceDayOfWeek','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] recurrenceDayOfWeekMask_type_info = new String[]{'recurrenceDayOfWeekMask','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceEndDate_type_info = new String[]{'recurrenceEndDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceInstance_type_info = new String[]{'recurrenceInstance','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceInterval_type_info = new String[]{'recurrenceInterval','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceMonthOfYear_type_info = new String[]{'recurrenceMonthOfYear','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceStartDate_type_info = new String[]{'recurrenceStartDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceType_type_info = new String[]{'recurrenceType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] startTime_type_info = new String[]{'startTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'activityDate','businessHours','description','endTime','isRecurring','name','recurrenceDayOfMonth','recurrenceDayOfWeek','recurrenceDayOfWeekMask','recurrenceEndDate','recurrenceInstance','recurrenceInterval','recurrenceMonthOfYear','recurrenceStartDate','recurrenceType','startTime'};
    }
    public with sharing class FlowElementReferenceOrValue {
        public Boolean booleanValue;
        public DateTime dateTimeValue;
        public Date dateValue;
        public String elementReference;
        public Double numberValue;
        public String stringValue;
        private String[] booleanValue_type_info = new String[]{'booleanValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','true'};
        private String[] dateTimeValue_type_info = new String[]{'dateTimeValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] dateValue_type_info = new String[]{'dateValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] elementReference_type_info = new String[]{'elementReference','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] numberValue_type_info = new String[]{'numberValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','true'};
        private String[] stringValue_type_info = new String[]{'stringValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanValue','dateTimeValue','dateValue','elementReference','numberValue','stringValue'};
    }
    public with sharing class EntitlementTemplate extends Metadata {
        public String type = 'EntitlementTemplate';
        public String fullName;
        public String businessHours;
        public Integer casesPerEntitlement;
        public String entitlementProcess;
        public Boolean isPerIncident;
        public Integer term;
        public String type_x;
        private String[] businessHours_type_info = new String[]{'businessHours','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] casesPerEntitlement_type_info = new String[]{'casesPerEntitlement','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] entitlementProcess_type_info = new String[]{'entitlementProcess','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isPerIncident_type_info = new String[]{'isPerIncident','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] term_type_info = new String[]{'term','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'businessHours','casesPerEntitlement','entitlementProcess','isPerIncident','term','type_x'};
    }
    public with sharing class ProfileTabVisibility {
        public String tab;
        public String visibility;
        private String[] tab_type_info = new String[]{'tab','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visibility_type_info = new String[]{'visibility','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'tab','visibility'};
    }
    public with sharing class ActionOverride {
        public String actionName;
        public String comment;
        public String content;
        public Boolean skipRecordTypeSelect;
        public String type_x;
        private String[] actionName_type_info = new String[]{'actionName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] comment_type_info = new String[]{'comment','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] content_type_info = new String[]{'content','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] skipRecordTypeSelect_type_info = new String[]{'skipRecordTypeSelect','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'actionName','comment','content','skipRecordTypeSelect','type_x'};
    }
    public with sharing class SaveResult {
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fullName_type_info = new String[]{'fullName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'errors','fullName','success'};
    }
    public with sharing class readMetadataResponse_element {
        public MetadataService.ReadResult result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public virtual class WorkflowAction extends Metadata{
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public with sharing class WorkspaceMappings {
        public MetadataService.WorkspaceMapping[] mapping;
        private String[] mapping_type_info = new String[]{'mapping','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'mapping'};
    }
    public with sharing class ContractSettings extends Metadata {
        public String type = 'ContractSettings';
        public String fullName;
        public Boolean autoCalculateEndDate;
        public String autoExpirationDelay;
        public String autoExpirationRecipient;
        public Boolean autoExpireContracts;
        public Boolean enableContractHistoryTracking;
        public Boolean notifyOwnersOnContractExpiration;
        private String[] autoCalculateEndDate_type_info = new String[]{'autoCalculateEndDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] autoExpirationDelay_type_info = new String[]{'autoExpirationDelay','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] autoExpirationRecipient_type_info = new String[]{'autoExpirationRecipient','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] autoExpireContracts_type_info = new String[]{'autoExpireContracts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableContractHistoryTracking_type_info = new String[]{'enableContractHistoryTracking','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyOwnersOnContractExpiration_type_info = new String[]{'notifyOwnersOnContractExpiration','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'autoCalculateEndDate','autoExpirationDelay','autoExpirationRecipient','autoExpireContracts','enableContractHistoryTracking','notifyOwnersOnContractExpiration'};
    }
    public with sharing class GlobalQuickActionTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class ReputationLevelDefinitions {
        public MetadataService.ReputationLevel[] level;
        private String[] level_type_info = new String[]{'level','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'level'};
    }
    public with sharing class LayoutTranslation {
        public String layout;
        public String layoutType;
        public MetadataService.LayoutSectionTranslation[] sections;
        private String[] layout_type_info = new String[]{'layout','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] layoutType_type_info = new String[]{'layoutType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sections_type_info = new String[]{'sections','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'layout','layoutType','sections'};
    }
    public with sharing class ApexTrigger extends MetadataWithContent {
        public String type = 'ApexTrigger';
        public String fullName;
        public String content;
        public Double apiVersion;
        public MetadataService.PackageVersion[] packageVersions;
        public String status;
        private String[] apiVersion_type_info = new String[]{'apiVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] packageVersions_type_info = new String[]{'packageVersions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] status_type_info = new String[]{'status','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'apiVersion','packageVersions','status'};
    }
    public with sharing class CustomApplicationTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class ApprovalStepApprover {
        public MetadataService.Approver[] approver;
        public String whenMultipleApprovers;
        private String[] approver_type_info = new String[]{'approver','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] whenMultipleApprovers_type_info = new String[]{'whenMultipleApprovers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'approver','whenMultipleApprovers'};
    }
    public with sharing class CallCenter extends Metadata {
        public String type = 'CallCenter';
        public String fullName;
        public String adapterUrl;
        public String customSettings;
        public String displayName;
        public String displayNameLabel;
        public String internalNameLabel;
        public MetadataService.CallCenterSection[] sections;
        public String version;
        private String[] adapterUrl_type_info = new String[]{'adapterUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customSettings_type_info = new String[]{'customSettings','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayName_type_info = new String[]{'displayName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] displayNameLabel_type_info = new String[]{'displayNameLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] internalNameLabel_type_info = new String[]{'internalNameLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sections_type_info = new String[]{'sections','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] version_type_info = new String[]{'version','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'adapterUrl','customSettings','displayName','displayNameLabel','internalNameLabel','sections','version'};
    }
    public with sharing class FlexiPageRegion {
        public MetadataService.ComponentInstance[] componentInstances;
        public String name;
        private String[] componentInstances_type_info = new String[]{'componentInstances','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'componentInstances','name'};
    }
    public with sharing class PicklistValue extends Metadata {
        public String type = 'PicklistValue';
        public String fullName;
        public Boolean allowEmail;
        public Boolean closed;
        public String color;
        public String[] controllingFieldValues;
        public Boolean converted;
        public Boolean cssExposed;
        public Boolean default_x;
        public String description;
        public String forecastCategory;
        public Boolean highPriority;
        public Integer probability;
        public String reverseRole;
        public Boolean reviewed;
        public Boolean won;
        private String[] allowEmail_type_info = new String[]{'allowEmail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] closed_type_info = new String[]{'closed','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] color_type_info = new String[]{'color','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] controllingFieldValues_type_info = new String[]{'controllingFieldValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] converted_type_info = new String[]{'converted','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] cssExposed_type_info = new String[]{'cssExposed','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] default_x_type_info = new String[]{'default','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] forecastCategory_type_info = new String[]{'forecastCategory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] highPriority_type_info = new String[]{'highPriority','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] probability_type_info = new String[]{'probability','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reverseRole_type_info = new String[]{'reverseRole','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reviewed_type_info = new String[]{'reviewed','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] won_type_info = new String[]{'won','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'allowEmail','closed','color','controllingFieldValues','converted','cssExposed','default_x','description','forecastCategory','highPriority','probability','reverseRole','reviewed','won'};
    }
    public with sharing class RemoteSiteSetting extends Metadata {
        public String type = 'RemoteSiteSetting';
        public String fullName;
        public String description;
        public Boolean disableProtocolSecurity;
        public Boolean isActive;
        public String url;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] disableProtocolSecurity_type_info = new String[]{'disableProtocolSecurity','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] url_type_info = new String[]{'url','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','disableProtocolSecurity','isActive','url'};
    }
    public with sharing class retrieveResponse_element {
        public MetadataService.AsyncResult result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class deploy_element {
        public String ZipFile;
        public MetadataService.DeployOptions DeployOptions;
        private String[] ZipFile_type_info = new String[]{'ZipFile','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] DeployOptions_type_info = new String[]{'DeployOptions','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'ZipFile','DeployOptions'};
    }
    public with sharing class XOrgHubSharedObject {
        public String[] fields;
        public String name;
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fields','name'};
    }
    public with sharing class Territory2Type extends Metadata {
        public String type = 'Territory2Type';
        public String fullName;
        public String description;
        public String name;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','name'};
    }
    public with sharing class SharingRecalculation {
        public String className;
        private String[] className_type_info = new String[]{'className','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'className'};
    }
    public with sharing class QuoteSettings extends Metadata {
        public String type = 'QuoteSettings';
        public String fullName;
        public Boolean enableQuote;
        private String[] enableQuote_type_info = new String[]{'enableQuote','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'enableQuote'};
    }
    public with sharing class WebLinkTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class ProfileLoginIpRange {
        public String description;
        public String endAddress;
        public String startAddress;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] endAddress_type_info = new String[]{'endAddress','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] startAddress_type_info = new String[]{'startAddress','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','endAddress','startAddress'};
    }
    public with sharing class ObjectRelationship {
        public MetadataService.ObjectRelationship join_x;
        public Boolean outerJoin;
        public String relationship;
        private String[] join_x_type_info = new String[]{'join','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] outerJoin_type_info = new String[]{'outerJoin','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] relationship_type_info = new String[]{'relationship','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'join_x','outerJoin','relationship'};
    }
    public with sharing class RuleEntry {
        public String assignedTo;
        public String assignedToType;
        public String booleanFilter;
        public String businessHours;
        public String businessHoursSource;
        public MetadataService.FilterItem[] criteriaItems;
        public Boolean disableEscalationWhenModified;
        public MetadataService.EscalationAction[] escalationAction;
        public String escalationStartTime;
        public String formula;
        public Boolean notifyCcRecipients;
        public Boolean overrideExistingTeams;
        public String replyToEmail;
        public String senderEmail;
        public String senderName;
        public String[] team;
        public String template;
        private String[] assignedTo_type_info = new String[]{'assignedTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assignedToType_type_info = new String[]{'assignedToType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] businessHours_type_info = new String[]{'businessHours','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] businessHoursSource_type_info = new String[]{'businessHoursSource','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] criteriaItems_type_info = new String[]{'criteriaItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] disableEscalationWhenModified_type_info = new String[]{'disableEscalationWhenModified','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] escalationAction_type_info = new String[]{'escalationAction','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] escalationStartTime_type_info = new String[]{'escalationStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] formula_type_info = new String[]{'formula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyCcRecipients_type_info = new String[]{'notifyCcRecipients','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] overrideExistingTeams_type_info = new String[]{'overrideExistingTeams','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] replyToEmail_type_info = new String[]{'replyToEmail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] senderEmail_type_info = new String[]{'senderEmail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] senderName_type_info = new String[]{'senderName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] team_type_info = new String[]{'team','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] template_type_info = new String[]{'template','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignedTo','assignedToType','booleanFilter','businessHours','businessHoursSource','criteriaItems','disableEscalationWhenModified','escalationAction','escalationStartTime','formula','notifyCcRecipients','overrideExistingTeams','replyToEmail','senderEmail','senderName','team','template'};
    }
    public with sharing class deleteMetadata_element {
        public String type_x;
        public String[] fullNames;
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fullNames_type_info = new String[]{'fullNames','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','fullNames'};
    }
    public with sharing class ListPlacement {
        public Integer height;
        public String location;
        public String units;
        public Integer width;
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] location_type_info = new String[]{'location','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] units_type_info = new String[]{'units','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'height','location','units','width'};
    }
    public with sharing class SiteRedirectMapping {
        public String action;
        public Boolean isActive;
        public String source;
        public String target;
        private String[] action_type_info = new String[]{'action','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] source_type_info = new String[]{'source','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] target_type_info = new String[]{'target','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'action','isActive','source','target'};
    }
    public with sharing class OwnerSharingRule {
        public MetadataService.SharedTo sharedFrom;
        private String[] sharedFrom_type_info = new String[]{'sharedFrom','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'sharedFrom'};
    }
    public with sharing class WorkflowFieldUpdate extends WorkflowAction {
        public String type = 'WorkflowFieldUpdate';
        public String fullName;
        public String description;
        public String field;
        public String formula;
        public String literalValue;
        public String lookupValue;
        public String lookupValueType;
        public String name;
        public Boolean notifyAssignee;
        public String operation;
        public Boolean protected_x;
        public Boolean reevaluateOnChange;
        public String targetObject;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] formula_type_info = new String[]{'formula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] literalValue_type_info = new String[]{'literalValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lookupValue_type_info = new String[]{'lookupValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lookupValueType_type_info = new String[]{'lookupValueType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] notifyAssignee_type_info = new String[]{'notifyAssignee','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] operation_type_info = new String[]{'operation','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] reevaluateOnChange_type_info = new String[]{'reevaluateOnChange','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] targetObject_type_info = new String[]{'targetObject','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','field','formula','literalValue','lookupValue','lookupValueType','name','notifyAssignee','operation','protected_x','reevaluateOnChange','targetObject'};
    }
    public with sharing class OpportunityCriteriaBasedSharingRule {
        public String booleanFilter;
        public String description;
        public String name;
        public String opportunityAccessLevel;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] opportunityAccessLevel_type_info = new String[]{'opportunityAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanFilter','description','name','opportunityAccessLevel'};
    }
    public with sharing class LetterheadLine {
        public String color;
        public Integer height;
        private String[] color_type_info = new String[]{'color','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'color','height'};
    }
    public with sharing class FlowChoiceUserInput {
        public Boolean isRequired;
        public String promptText;
        public MetadataService.FlowInputValidationRule validationRule;
        private String[] isRequired_type_info = new String[]{'isRequired','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] promptText_type_info = new String[]{'promptText','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] validationRule_type_info = new String[]{'validationRule','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'isRequired','promptText','validationRule'};
    }
    public with sharing class ConnectedAppMobileDetailConfig {
        public String applicationBinaryFile;
        public String applicationBinaryFileName;
        public String applicationBundleIdentifier;
        public Integer applicationFileLength;
        public String applicationIconFile;
        public String applicationIconFileName;
        public String applicationInstallUrl;
        public String devicePlatform;
        public String deviceType;
        public String minimumOsVersion;
        public Boolean privateApp;
        public String version;
        private String[] applicationBinaryFile_type_info = new String[]{'applicationBinaryFile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] applicationBinaryFileName_type_info = new String[]{'applicationBinaryFileName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] applicationBundleIdentifier_type_info = new String[]{'applicationBundleIdentifier','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] applicationFileLength_type_info = new String[]{'applicationFileLength','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] applicationIconFile_type_info = new String[]{'applicationIconFile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] applicationIconFileName_type_info = new String[]{'applicationIconFileName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] applicationInstallUrl_type_info = new String[]{'applicationInstallUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] devicePlatform_type_info = new String[]{'devicePlatform','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] deviceType_type_info = new String[]{'deviceType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] minimumOsVersion_type_info = new String[]{'minimumOsVersion','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] privateApp_type_info = new String[]{'privateApp','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] version_type_info = new String[]{'version','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'applicationBinaryFile','applicationBinaryFileName','applicationBundleIdentifier','applicationFileLength','applicationIconFile','applicationIconFileName','applicationInstallUrl','devicePlatform','deviceType','minimumOsVersion','privateApp','version'};
    }
    public with sharing class CriteriaBasedSharingRule {
        public MetadataService.FilterItem[] criteriaItems;
        private String[] criteriaItems_type_info = new String[]{'criteriaItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaItems'};
    }
    public with sharing class ProfileRecordTypeVisibility {
        public Boolean default_x;
        public Boolean personAccountDefault;
        public String recordType;
        public Boolean visible;
        private String[] default_x_type_info = new String[]{'default','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] personAccountDefault_type_info = new String[]{'personAccountDefault','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recordType_type_info = new String[]{'recordType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visible_type_info = new String[]{'visible','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'default_x','personAccountDefault','recordType','visible'};
    }
    public with sharing class PackageVersion {
        public Integer majorNumber;
        public Integer minorNumber;
        public String namespace;
        private String[] majorNumber_type_info = new String[]{'majorNumber','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] minorNumber_type_info = new String[]{'minorNumber','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] namespace_type_info = new String[]{'namespace','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'majorNumber','minorNumber','namespace'};
    }
    public with sharing class PermissionSetCustomPermissions {
        public Boolean enabled;
        public String name;
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enabled','name'};
    }
    public with sharing class CustomLabelTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class LeadOwnerSharingRule {
        public String description;
        public String leadAccessLevel;
        public String name;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] leadAccessLevel_type_info = new String[]{'leadAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','leadAccessLevel','name'};
    }
    public with sharing class CorsWhitelistOrigin extends Metadata {
        public String type = 'CorsWhitelistOrigin';
        public String fullName;
        public String urlPattern;
        private String[] urlPattern_type_info = new String[]{'urlPattern','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'urlPattern'};
    }
    public with sharing class StaticResource extends MetadataWithContent {
        public String type = 'StaticResource';
        public String fullName;
        public String content;
        public String cacheControl;
        public String contentType;
        public String description;
        private String[] cacheControl_type_info = new String[]{'cacheControl','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] contentType_type_info = new String[]{'contentType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'cacheControl','contentType','description'};
    }
    public with sharing class LiveChatButton extends Metadata {
        public String type = 'LiveChatButton';
        public String fullName;
        public String animation;
        public String autoGreeting;
        public String chatPage;
        public String customAgentName;
        public MetadataService.LiveChatButtonDeployments deployments;
        public Boolean enableQueue;
        public String inviteEndPosition;
        public String inviteImage;
        public String inviteStartPosition;
        public Boolean isActive;
        public String label;
        public Integer numberOfReroutingAttempts;
        public String offlineImage;
        public String onlineImage;
        public Boolean optionsCustomRoutingIsEnabled;
        public Boolean optionsHasInviteAfterAccept;
        public Boolean optionsHasInviteAfterReject;
        public Boolean optionsHasRerouteDeclinedRequest;
        public Boolean optionsIsAutoAccept;
        public Boolean optionsIsInviteAutoRemove;
        public Integer overallQueueLength;
        public Integer perAgentQueueLength;
        public String postChatPage;
        public String postChatUrl;
        public String preChatFormPage;
        public String preChatFormUrl;
        public Integer pushTimeOut;
        public String routingType;
        public String site;
        public MetadataService.LiveChatButtonSkills skills;
        public Integer timeToRemoveInvite;
        public String type_x;
        public String windowLanguage;
        private String[] animation_type_info = new String[]{'animation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] autoGreeting_type_info = new String[]{'autoGreeting','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chatPage_type_info = new String[]{'chatPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customAgentName_type_info = new String[]{'customAgentName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] deployments_type_info = new String[]{'deployments','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableQueue_type_info = new String[]{'enableQueue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inviteEndPosition_type_info = new String[]{'inviteEndPosition','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inviteImage_type_info = new String[]{'inviteImage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inviteStartPosition_type_info = new String[]{'inviteStartPosition','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numberOfReroutingAttempts_type_info = new String[]{'numberOfReroutingAttempts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] offlineImage_type_info = new String[]{'offlineImage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] onlineImage_type_info = new String[]{'onlineImage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] optionsCustomRoutingIsEnabled_type_info = new String[]{'optionsCustomRoutingIsEnabled','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] optionsHasInviteAfterAccept_type_info = new String[]{'optionsHasInviteAfterAccept','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] optionsHasInviteAfterReject_type_info = new String[]{'optionsHasInviteAfterReject','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] optionsHasRerouteDeclinedRequest_type_info = new String[]{'optionsHasRerouteDeclinedRequest','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] optionsIsAutoAccept_type_info = new String[]{'optionsIsAutoAccept','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] optionsIsInviteAutoRemove_type_info = new String[]{'optionsIsInviteAutoRemove','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] overallQueueLength_type_info = new String[]{'overallQueueLength','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] perAgentQueueLength_type_info = new String[]{'perAgentQueueLength','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] postChatPage_type_info = new String[]{'postChatPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] postChatUrl_type_info = new String[]{'postChatUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] preChatFormPage_type_info = new String[]{'preChatFormPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] preChatFormUrl_type_info = new String[]{'preChatFormUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] pushTimeOut_type_info = new String[]{'pushTimeOut','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] routingType_type_info = new String[]{'routingType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] site_type_info = new String[]{'site','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] skills_type_info = new String[]{'skills','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] timeToRemoveInvite_type_info = new String[]{'timeToRemoveInvite','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] windowLanguage_type_info = new String[]{'windowLanguage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'animation','autoGreeting','chatPage','customAgentName','deployments','enableQueue','inviteEndPosition','inviteImage','inviteStartPosition','isActive','label','numberOfReroutingAttempts','offlineImage','onlineImage','optionsCustomRoutingIsEnabled','optionsHasInviteAfterAccept','optionsHasInviteAfterReject','optionsHasRerouteDeclinedRequest','optionsIsAutoAccept','optionsIsInviteAutoRemove','overallQueueLength','perAgentQueueLength','postChatPage','postChatUrl','preChatFormPage','preChatFormUrl','pushTimeOut','routingType','site','skills','timeToRemoveInvite','type_x','windowLanguage'};
    }
    public with sharing class RunTestsResult {
        public MetadataService.CodeCoverageResult[] codeCoverage;
        public MetadataService.CodeCoverageWarning[] codeCoverageWarnings;
        public MetadataService.RunTestFailure[] failures;
        public Integer numFailures;
        public Integer numTestsRun;
        public MetadataService.RunTestSuccess[] successes;
        public Double totalTime;
        private String[] codeCoverage_type_info = new String[]{'codeCoverage','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] codeCoverageWarnings_type_info = new String[]{'codeCoverageWarnings','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] failures_type_info = new String[]{'failures','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] numFailures_type_info = new String[]{'numFailures','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numTestsRun_type_info = new String[]{'numTestsRun','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] successes_type_info = new String[]{'successes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] totalTime_type_info = new String[]{'totalTime','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'codeCoverage','codeCoverageWarnings','failures','numFailures','numTestsRun','successes','totalTime'};
    }
    public with sharing class Network extends Metadata {
        public String type = 'Network';
        public String fullName;
        public Boolean allowMembersToFlag;
        public MetadataService.Branding branding;
        public String caseCommentEmailTemplate;
        public String changePasswordTemplate;
        public String description;
        public String emailSenderAddress;
        public String emailSenderName;
        public Boolean enableGuestChatter;
        public Boolean enableInvitation;
        public Boolean enableKnowledgeable;
        public Boolean enableNicknameDisplay;
        public Boolean enablePrivateMessages;
        public Boolean enableReputation;
        public String feedChannel;
        public String forgotPasswordTemplate;
        public String logoutUrl;
        public MetadataService.NetworkMemberGroup networkMemberGroups;
        public String newSenderAddress;
        public String picassoSite;
        public MetadataService.ReputationLevelDefinitions reputationLevels;
        public MetadataService.ReputationPointsRules reputationPointsRules;
        public String selfRegProfile;
        public Boolean selfRegistration;
        public Boolean sendWelcomeEmail;
        public String site;
        public String status;
        public MetadataService.NetworkTabSet tabs;
        public String urlPathPrefix;
        public String welcomeTemplate;
        private String[] allowMembersToFlag_type_info = new String[]{'allowMembersToFlag','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] branding_type_info = new String[]{'branding','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseCommentEmailTemplate_type_info = new String[]{'caseCommentEmailTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] changePasswordTemplate_type_info = new String[]{'changePasswordTemplate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailSenderAddress_type_info = new String[]{'emailSenderAddress','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] emailSenderName_type_info = new String[]{'emailSenderName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enableGuestChatter_type_info = new String[]{'enableGuestChatter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableInvitation_type_info = new String[]{'enableInvitation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableKnowledgeable_type_info = new String[]{'enableKnowledgeable','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableNicknameDisplay_type_info = new String[]{'enableNicknameDisplay','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enablePrivateMessages_type_info = new String[]{'enablePrivateMessages','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableReputation_type_info = new String[]{'enableReputation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] feedChannel_type_info = new String[]{'feedChannel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] forgotPasswordTemplate_type_info = new String[]{'forgotPasswordTemplate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] logoutUrl_type_info = new String[]{'logoutUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] networkMemberGroups_type_info = new String[]{'networkMemberGroups','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] newSenderAddress_type_info = new String[]{'newSenderAddress','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] picassoSite_type_info = new String[]{'picassoSite','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reputationLevels_type_info = new String[]{'reputationLevels','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reputationPointsRules_type_info = new String[]{'reputationPointsRules','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] selfRegProfile_type_info = new String[]{'selfRegProfile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] selfRegistration_type_info = new String[]{'selfRegistration','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sendWelcomeEmail_type_info = new String[]{'sendWelcomeEmail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] site_type_info = new String[]{'site','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] status_type_info = new String[]{'status','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] tabs_type_info = new String[]{'tabs','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] urlPathPrefix_type_info = new String[]{'urlPathPrefix','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] welcomeTemplate_type_info = new String[]{'welcomeTemplate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'allowMembersToFlag','branding','caseCommentEmailTemplate','changePasswordTemplate','description','emailSenderAddress','emailSenderName','enableGuestChatter','enableInvitation','enableKnowledgeable','enableNicknameDisplay','enablePrivateMessages','enableReputation','feedChannel','forgotPasswordTemplate','logoutUrl','networkMemberGroups','newSenderAddress','picassoSite','reputationLevels','reputationPointsRules','selfRegProfile','selfRegistration','sendWelcomeEmail','site','status','tabs','urlPathPrefix','welcomeTemplate'};
    }
    public with sharing class PermissionSetUserPermission {
        public Boolean enabled;
        public String name;
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enabled','name'};
    }
    public with sharing class FlowVariable {
        public String dataType;
        public Boolean isCollection;
        public Boolean isInput;
        public Boolean isOutput;
        public String objectType;
        public Integer scale;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] dataType_type_info = new String[]{'dataType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isCollection_type_info = new String[]{'isCollection','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isInput_type_info = new String[]{'isInput','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isOutput_type_info = new String[]{'isOutput','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] objectType_type_info = new String[]{'objectType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scale_type_info = new String[]{'scale','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dataType','isCollection','isInput','isOutput','objectType','scale','value'};
    }
    public with sharing class AccountSettings extends Metadata {
        public String type = 'AccountSettings';
        public String fullName;
        public Boolean enableAccountOwnerReport;
        public Boolean enableAccountTeams;
        public Boolean showViewHierarchyLink;
        private String[] enableAccountOwnerReport_type_info = new String[]{'enableAccountOwnerReport','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableAccountTeams_type_info = new String[]{'enableAccountTeams','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showViewHierarchyLink_type_info = new String[]{'showViewHierarchyLink','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'enableAccountOwnerReport','enableAccountTeams','showViewHierarchyLink'};
    }
    public with sharing class ChatterAnswersReputationLevel {
        public String name;
        public Integer value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class LiveChatDeploymentDomainWhitelist {
        public String[] domain;
        private String[] domain_type_info = new String[]{'domain','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'domain'};
    }
    public with sharing class DashboardFilter {
        public MetadataService.DashboardFilterOption[] dashboardFilterOptions;
        public String name;
        private String[] dashboardFilterOptions_type_info = new String[]{'dashboardFilterOptions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dashboardFilterOptions','name'};
    }
    public with sharing class ProfileLoginHours {
        public String fridayEnd;
        public String fridayStart;
        public String mondayEnd;
        public String mondayStart;
        public String saturdayEnd;
        public String saturdayStart;
        public String sundayEnd;
        public String sundayStart;
        public String thursdayEnd;
        public String thursdayStart;
        public String tuesdayEnd;
        public String tuesdayStart;
        public String wednesdayEnd;
        public String wednesdayStart;
        private String[] fridayEnd_type_info = new String[]{'fridayEnd','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fridayStart_type_info = new String[]{'fridayStart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mondayEnd_type_info = new String[]{'mondayEnd','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mondayStart_type_info = new String[]{'mondayStart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] saturdayEnd_type_info = new String[]{'saturdayEnd','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] saturdayStart_type_info = new String[]{'saturdayStart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sundayEnd_type_info = new String[]{'sundayEnd','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sundayStart_type_info = new String[]{'sundayStart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] thursdayEnd_type_info = new String[]{'thursdayEnd','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] thursdayStart_type_info = new String[]{'thursdayStart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] tuesdayEnd_type_info = new String[]{'tuesdayEnd','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] tuesdayStart_type_info = new String[]{'tuesdayStart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] wednesdayEnd_type_info = new String[]{'wednesdayEnd','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] wednesdayStart_type_info = new String[]{'wednesdayStart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fridayEnd','fridayStart','mondayEnd','mondayStart','saturdayEnd','saturdayStart','sundayEnd','sundayStart','thursdayEnd','thursdayStart','tuesdayEnd','tuesdayStart','wednesdayEnd','wednesdayStart'};
    }
    public with sharing class CodeLocation {
        public Integer column;
        public Integer line;
        public Integer numExecutions;
        public Double time_x;
        private String[] column_type_info = new String[]{'column','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] line_type_info = new String[]{'line','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numExecutions_type_info = new String[]{'numExecutions','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] time_x_type_info = new String[]{'time','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'column','line','numExecutions','time_x'};
    }
    public with sharing class PermissionSetRecordTypeVisibility {
        public String recordType;
        public Boolean visible;
        private String[] recordType_type_info = new String[]{'recordType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visible_type_info = new String[]{'visible','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'recordType','visible'};
    }
    public with sharing class FieldSetItem {
        public String field;
        public Boolean isFieldManaged;
        public Boolean isRequired;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isFieldManaged_type_info = new String[]{'isFieldManaged','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isRequired_type_info = new String[]{'isRequired','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','isFieldManaged','isRequired'};
    }
    public with sharing class KnowledgeLanguageSettings {
        public MetadataService.KnowledgeLanguage[] language;
        private String[] language_type_info = new String[]{'language','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'language'};
    }
    public with sharing class OrderSettings extends Metadata {
        public String type = 'OrderSettings';
        public String fullName;
        public Boolean enableNegativeQuantity;
        public Boolean enableOrders;
        public Boolean enableReductionOrders;
        private String[] enableNegativeQuantity_type_info = new String[]{'enableNegativeQuantity','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableOrders_type_info = new String[]{'enableOrders','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableReductionOrders_type_info = new String[]{'enableReductionOrders','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'enableNegativeQuantity','enableOrders','enableReductionOrders'};
    }
    public with sharing class ProfileUserPermission {
        public Boolean enabled;
        public String name;
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enabled','name'};
    }
    public with sharing class ReportFilterItem {
        public String column;
        public Boolean columnToColumn;
        public String operator;
        public String snapshot;
        public String value;
        private String[] column_type_info = new String[]{'column','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] columnToColumn_type_info = new String[]{'columnToColumn','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] operator_type_info = new String[]{'operator','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] snapshot_type_info = new String[]{'snapshot','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'column','columnToColumn','operator','snapshot','value'};
    }
    public with sharing class FlowDynamicChoiceSet {
        public String dataType;
        public String displayField;
        public MetadataService.FlowRecordFilter[] filters;
        public Integer limit_x;
        public String object_x;
        public MetadataService.FlowOutputFieldAssignment[] outputAssignments;
        public String sortField;
        public String sortOrder;
        public String valueField;
        private String[] dataType_type_info = new String[]{'dataType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] displayField_type_info = new String[]{'displayField','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] filters_type_info = new String[]{'filters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] limit_x_type_info = new String[]{'limit','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] outputAssignments_type_info = new String[]{'outputAssignments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] sortField_type_info = new String[]{'sortField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortOrder_type_info = new String[]{'sortOrder','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] valueField_type_info = new String[]{'valueField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dataType','displayField','filters','limit_x','object_x','outputAssignments','sortField','sortOrder','valueField'};
    }
    public with sharing class KnowledgeSettings extends Metadata {
        public String type = 'KnowledgeSettings';
        public String fullName;
        public MetadataService.KnowledgeAnswerSettings answers;
        public MetadataService.KnowledgeCaseSettings cases;
        public String defaultLanguage;
        public Boolean enableChatterQuestionKBDeflection;
        public Boolean enableCreateEditOnArticlesTab;
        public Boolean enableExternalMediaContent;
        public Boolean enableKnowledge;
        public MetadataService.KnowledgeLanguageSettings languages;
        public Boolean showArticleSummariesCustomerPortal;
        public Boolean showArticleSummariesInternalApp;
        public Boolean showArticleSummariesPartnerPortal;
        public Boolean showValidationStatusField;
        private String[] answers_type_info = new String[]{'answers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] cases_type_info = new String[]{'cases','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultLanguage_type_info = new String[]{'defaultLanguage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableChatterQuestionKBDeflection_type_info = new String[]{'enableChatterQuestionKBDeflection','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableCreateEditOnArticlesTab_type_info = new String[]{'enableCreateEditOnArticlesTab','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableExternalMediaContent_type_info = new String[]{'enableExternalMediaContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableKnowledge_type_info = new String[]{'enableKnowledge','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] languages_type_info = new String[]{'languages','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showArticleSummariesCustomerPortal_type_info = new String[]{'showArticleSummariesCustomerPortal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showArticleSummariesInternalApp_type_info = new String[]{'showArticleSummariesInternalApp','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showArticleSummariesPartnerPortal_type_info = new String[]{'showArticleSummariesPartnerPortal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showValidationStatusField_type_info = new String[]{'showValidationStatusField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'answers','cases','defaultLanguage','enableChatterQuestionKBDeflection','enableCreateEditOnArticlesTab','enableExternalMediaContent','enableKnowledge','languages','showArticleSummariesCustomerPortal','showArticleSummariesInternalApp','showArticleSummariesPartnerPortal','showValidationStatusField'};
    }
    public with sharing class StandardFieldTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class upsertMetadata_element {
        public MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'metadata'};
    }
    public with sharing class ApexClass extends MetadataWithContent {
        public String type = 'ApexClass';
        public String fullName;
        public String content;
        public Double apiVersion;
        public MetadataService.PackageVersion[] packageVersions;
        public String status;
        private String[] apiVersion_type_info = new String[]{'apiVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] packageVersions_type_info = new String[]{'packageVersions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] status_type_info = new String[]{'status','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'apiVersion','packageVersions','status'};
    }
    public with sharing class SessionSettings {
        public Boolean disableTimeoutWarning;
        public Boolean enableCSRFOnGet;
        public Boolean enableCSRFOnPost;
        public Boolean enableCacheAndAutocomplete;
        public Boolean enableClickjackNonsetupSFDC;
        public Boolean enableClickjackNonsetupUser;
        public Boolean enableClickjackSetup;
        public Boolean enablePostForSessions;
        public Boolean enableSMSIdentity;
        public Boolean forceLogoutOnSessionTimeout;
        public Boolean forceRelogin;
        public Boolean lockSessionsToIp;
        public String sessionTimeout;
        private String[] disableTimeoutWarning_type_info = new String[]{'disableTimeoutWarning','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableCSRFOnGet_type_info = new String[]{'enableCSRFOnGet','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableCSRFOnPost_type_info = new String[]{'enableCSRFOnPost','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableCacheAndAutocomplete_type_info = new String[]{'enableCacheAndAutocomplete','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableClickjackNonsetupSFDC_type_info = new String[]{'enableClickjackNonsetupSFDC','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableClickjackNonsetupUser_type_info = new String[]{'enableClickjackNonsetupUser','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableClickjackSetup_type_info = new String[]{'enableClickjackSetup','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enablePostForSessions_type_info = new String[]{'enablePostForSessions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSMSIdentity_type_info = new String[]{'enableSMSIdentity','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] forceLogoutOnSessionTimeout_type_info = new String[]{'forceLogoutOnSessionTimeout','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] forceRelogin_type_info = new String[]{'forceRelogin','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lockSessionsToIp_type_info = new String[]{'lockSessionsToIp','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sessionTimeout_type_info = new String[]{'sessionTimeout','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'disableTimeoutWarning','enableCSRFOnGet','enableCSRFOnPost','enableCacheAndAutocomplete','enableClickjackNonsetupSFDC','enableClickjackNonsetupUser','enableClickjackSetup','enablePostForSessions','enableSMSIdentity','forceLogoutOnSessionTimeout','forceRelogin','lockSessionsToIp','sessionTimeout'};
    }
    public with sharing class Document extends MetadataWithContent {
        public String type = 'Document';
        public String fullName;
        public String content;
        public String description;
        public Boolean internalUseOnly;
        public String keywords;
        public String name;
        public Boolean public_x;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] internalUseOnly_type_info = new String[]{'internalUseOnly','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] keywords_type_info = new String[]{'keywords','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] public_x_type_info = new String[]{'public','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'description','internalUseOnly','keywords','name','public_x'};
    }
    public with sharing class AutoResponseRules extends Metadata {
        public String type = 'AutoResponseRules';
        public String fullName;
        public MetadataService.AutoResponseRule[] autoResponseRule;
        private String[] autoResponseRule_type_info = new String[]{'autoResponseRule','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'autoResponseRule'};
    }
    public virtual class Folder extends Metadata{
        public String accessType;
        public MetadataService.FolderShare[] folderShares;
        public String name;
        public String publicFolderAccess;
        public MetadataService.SharedTo sharedTo;
        private String[] accessType_type_info = new String[]{'accessType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] folderShares_type_info = new String[]{'folderShares','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] publicFolderAccess_type_info = new String[]{'publicFolderAccess','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sharedTo_type_info = new String[]{'sharedTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accessType','folderShares','name','publicFolderAccess','sharedTo'};
    }
    public with sharing class Territory2Model extends Metadata {
        public String type = 'Territory2Model';
        public String fullName;
        public MetadataService.FieldValue[] customFields;
        public String description;
        public String name;
        private String[] customFields_type_info = new String[]{'customFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'customFields','description','name'};
    }
    public with sharing class DeployResult {
        public String canceledBy;
        public String canceledByName;
        public Boolean checkOnly;
        public DateTime completedDate;
        public String createdBy;
        public String createdByName;
        public DateTime createdDate;
        public MetadataService.DeployDetails details;
        public Boolean done;
        public String errorMessage;
        public String errorStatusCode;
        public String id;
        public Boolean ignoreWarnings;
        public DateTime lastModifiedDate;
        public Integer numberComponentErrors;
        public Integer numberComponentsDeployed;
        public Integer numberComponentsTotal;
        public Integer numberTestErrors;
        public Integer numberTestsCompleted;
        public Integer numberTestsTotal;
        public Boolean rollbackOnError;
        public Boolean runTestsEnabled;
        public DateTime startDate;
        public String stateDetail;
        public String status;
        public Boolean success;
        private String[] canceledBy_type_info = new String[]{'canceledBy','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] canceledByName_type_info = new String[]{'canceledByName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] checkOnly_type_info = new String[]{'checkOnly','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] completedDate_type_info = new String[]{'completedDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] createdBy_type_info = new String[]{'createdBy','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] createdByName_type_info = new String[]{'createdByName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] createdDate_type_info = new String[]{'createdDate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] details_type_info = new String[]{'details','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] done_type_info = new String[]{'done','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] errorStatusCode_type_info = new String[]{'errorStatusCode','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] ignoreWarnings_type_info = new String[]{'ignoreWarnings','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lastModifiedDate_type_info = new String[]{'lastModifiedDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] numberComponentErrors_type_info = new String[]{'numberComponentErrors','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numberComponentsDeployed_type_info = new String[]{'numberComponentsDeployed','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numberComponentsTotal_type_info = new String[]{'numberComponentsTotal','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numberTestErrors_type_info = new String[]{'numberTestErrors','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numberTestsCompleted_type_info = new String[]{'numberTestsCompleted','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] numberTestsTotal_type_info = new String[]{'numberTestsTotal','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] rollbackOnError_type_info = new String[]{'rollbackOnError','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] runTestsEnabled_type_info = new String[]{'runTestsEnabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] stateDetail_type_info = new String[]{'stateDetail','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] status_type_info = new String[]{'status','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'canceledBy','canceledByName','checkOnly','completedDate','createdBy','createdByName','createdDate','details','done','errorMessage','errorStatusCode','id','ignoreWarnings','lastModifiedDate','numberComponentErrors','numberComponentsDeployed','numberComponentsTotal','numberTestErrors','numberTestsCompleted','numberTestsTotal','rollbackOnError','runTestsEnabled','startDate','stateDetail','status','success'};
    }
    public with sharing class CampaignCriteriaBasedSharingRule {
        public String booleanFilter;
        public String campaignAccessLevel;
        public String description;
        public String name;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] campaignAccessLevel_type_info = new String[]{'campaignAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanFilter','campaignAccessLevel','description','name'};
    }
    public with sharing class ProfileApexPageAccess {
        public String apexPage;
        public Boolean enabled;
        private String[] apexPage_type_info = new String[]{'apexPage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apexPage','enabled'};
    }
    public with sharing class UserCriteriaBasedSharingRule {
        public String booleanFilter;
        public String description;
        public String name;
        public String userAccessLevel;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] userAccessLevel_type_info = new String[]{'userAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanFilter','description','name','userAccessLevel'};
    }
    public with sharing class Approver {
        public String name;
        public String type_x;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','type_x'};
    }
    public with sharing class LetterheadHeaderFooter {
        public String backgroundColor;
        public Integer height;
        public String horizontalAlignment;
        public String logo;
        public String verticalAlignment;
        private String[] backgroundColor_type_info = new String[]{'backgroundColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] horizontalAlignment_type_info = new String[]{'horizontalAlignment','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] logo_type_info = new String[]{'logo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] verticalAlignment_type_info = new String[]{'verticalAlignment','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'backgroundColor','height','horizontalAlignment','logo','verticalAlignment'};
    }
    public with sharing class HomePageComponent extends Metadata {
        public String type = 'HomePageComponent';
        public String fullName;
        public String body;
        public Integer height;
        public String[] links;
        public String page_x;
        public String pageComponentType;
        public Boolean showLabel;
        public Boolean showScrollbars;
        public String width;
        private String[] body_type_info = new String[]{'body','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] links_type_info = new String[]{'links','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] pageComponentType_type_info = new String[]{'pageComponentType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] showLabel_type_info = new String[]{'showLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showScrollbars_type_info = new String[]{'showScrollbars','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'body','height','links','page_x','pageComponentType','showLabel','showScrollbars','width'};
    }
    public with sharing class ProfileCustomPermissions {
        public Boolean enabled;
        public String name;
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enabled','name'};
    }
    public with sharing class LookupFilterTranslation {
        public String errorMessage;
        public String informationalMessage;
        private String[] errorMessage_type_info = new String[]{'errorMessage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] informationalMessage_type_info = new String[]{'informationalMessage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'errorMessage','informationalMessage'};
    }
    public with sharing class SamlSsoConfig extends Metadata {
        public String type = 'SamlSsoConfig';
        public String fullName;
        public String attributeName;
        public String attributeNameIdFormat;
        public String decryptionCertificate;
        public String errorUrl;
        public String identityLocation;
        public String identityMapping;
        public String issuer;
        public String loginUrl;
        public String logoutUrl;
        public String name;
        public String oauthTokenEndpoint;
        public Boolean redirectBinding;
        public String salesforceLoginUrl;
        public String samlEntityId;
        public String samlVersion;
        public Boolean userProvisioning;
        public String validationCert;
        private String[] attributeName_type_info = new String[]{'attributeName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] attributeNameIdFormat_type_info = new String[]{'attributeNameIdFormat','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] decryptionCertificate_type_info = new String[]{'decryptionCertificate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] errorUrl_type_info = new String[]{'errorUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] identityLocation_type_info = new String[]{'identityLocation','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] identityMapping_type_info = new String[]{'identityMapping','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] issuer_type_info = new String[]{'issuer','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] loginUrl_type_info = new String[]{'loginUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] logoutUrl_type_info = new String[]{'logoutUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] oauthTokenEndpoint_type_info = new String[]{'oauthTokenEndpoint','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] redirectBinding_type_info = new String[]{'redirectBinding','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] salesforceLoginUrl_type_info = new String[]{'salesforceLoginUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] samlEntityId_type_info = new String[]{'samlEntityId','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] samlVersion_type_info = new String[]{'samlVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] userProvisioning_type_info = new String[]{'userProvisioning','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] validationCert_type_info = new String[]{'validationCert','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'attributeName','attributeNameIdFormat','decryptionCertificate','errorUrl','identityLocation','identityMapping','issuer','loginUrl','logoutUrl','name','oauthTokenEndpoint','redirectBinding','salesforceLoginUrl','samlEntityId','samlVersion','userProvisioning','validationCert'};
    }
    public with sharing class RecordTypeTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class WorkflowFlowAction {
        public String description;
        public String flow;
        public MetadataService.WorkflowFlowActionParameter[] flowInputs;
        public String label;
        public String language;
        public Boolean protected_x;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] flow_type_info = new String[]{'flow','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] flowInputs_type_info = new String[]{'flowInputs','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] language_type_info = new String[]{'language','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','flow','flowInputs','label','language','protected_x'};
    }
    public with sharing class MobileSettings extends Metadata {
        public String type = 'MobileSettings';
        public String fullName;
        public MetadataService.ChatterMobileSettings chatterMobile;
        public MetadataService.DashboardMobileSettings dashboardMobile;
        public MetadataService.SFDCMobileSettings salesforceMobile;
        public MetadataService.TouchMobileSettings touchMobile;
        private String[] chatterMobile_type_info = new String[]{'chatterMobile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] dashboardMobile_type_info = new String[]{'dashboardMobile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] salesforceMobile_type_info = new String[]{'salesforceMobile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] touchMobile_type_info = new String[]{'touchMobile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'chatterMobile','dashboardMobile','salesforceMobile','touchMobile'};
    }
    public with sharing class PersonListSettings {
        public Boolean enablePersonList;
        private String[] enablePersonList_type_info = new String[]{'enablePersonList','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enablePersonList'};
    }
    public with sharing class FlowFormula {
        public String dataType;
        public String expression;
        public Integer scale;
        private String[] dataType_type_info = new String[]{'dataType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] expression_type_info = new String[]{'expression','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] scale_type_info = new String[]{'scale','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dataType','expression','scale'};
    }
    public with sharing class EscalationRules extends Metadata {
        public String type = 'EscalationRules';
        public String fullName;
        public MetadataService.EscalationRule[] escalationRule;
        private String[] escalationRule_type_info = new String[]{'escalationRule','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'escalationRule'};
    }
    public with sharing class ApprovalSubmitter {
        public String submitter;
        public String type_x;
        private String[] submitter_type_info = new String[]{'submitter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'submitter','type_x'};
    }
    public with sharing class AgentConfigButtons {
        public String[] button;
        private String[] button_type_info = new String[]{'button','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'button'};
    }
    public with sharing class PicklistValueTranslation {
        public String masterLabel;
        public String translation;
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] translation_type_info = new String[]{'translation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'masterLabel','translation'};
    }
    public with sharing class ContactOwnerSharingRule {
        public String contactAccessLevel;
        public String description;
        public String name;
        private String[] contactAccessLevel_type_info = new String[]{'contactAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'contactAccessLevel','description','name'};
    }
    public with sharing class CustomDataType extends Metadata {
        public String type = 'CustomDataType';
        public String fullName;
        public MetadataService.CustomDataTypeComponent[] customDataTypeComponents;
        public String description;
        public String displayFormula;
        public Boolean editComponentsOnSeparateLines;
        public String label;
        public Boolean rightAligned;
        public Boolean supportComponentsInReports;
        private String[] customDataTypeComponents_type_info = new String[]{'customDataTypeComponents','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayFormula_type_info = new String[]{'displayFormula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] editComponentsOnSeparateLines_type_info = new String[]{'editComponentsOnSeparateLines','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] rightAligned_type_info = new String[]{'rightAligned','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] supportComponentsInReports_type_info = new String[]{'supportComponentsInReports','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'customDataTypeComponents','description','displayFormula','editComponentsOnSeparateLines','label','rightAligned','supportComponentsInReports'};
    }
    public with sharing class PrimaryTabComponents {
        public MetadataService.Container[] containers;
        private String[] containers_type_info = new String[]{'containers','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'containers'};
    }
    public with sharing class AgentConfigSkills {
        public String[] skill;
        private String[] skill_type_info = new String[]{'skill','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'skill'};
    }
    public with sharing class EntitlementProcess extends Metadata {
        public String type = 'EntitlementProcess';
        public String fullName;
        public Boolean active;
        public String businessHours;
        public String description;
        public String entryStartDateField;
        public String exitCriteriaBooleanFilter;
        public MetadataService.FilterItem[] exitCriteriaFilterItems;
        public String exitCriteriaFormula;
        public Boolean isVersionDefault;
        public MetadataService.EntitlementProcessMilestoneItem[] milestones;
        public String name;
        public String versionMaster;
        public String versionNotes;
        public Integer versionNumber;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] businessHours_type_info = new String[]{'businessHours','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] entryStartDateField_type_info = new String[]{'entryStartDateField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] exitCriteriaBooleanFilter_type_info = new String[]{'exitCriteriaBooleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] exitCriteriaFilterItems_type_info = new String[]{'exitCriteriaFilterItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] exitCriteriaFormula_type_info = new String[]{'exitCriteriaFormula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isVersionDefault_type_info = new String[]{'isVersionDefault','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] milestones_type_info = new String[]{'milestones','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] versionMaster_type_info = new String[]{'versionMaster','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] versionNotes_type_info = new String[]{'versionNotes','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] versionNumber_type_info = new String[]{'versionNumber','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','businessHours','description','entryStartDateField','exitCriteriaBooleanFilter','exitCriteriaFilterItems','exitCriteriaFormula','isVersionDefault','milestones','name','versionMaster','versionNotes','versionNumber'};
    }
    public with sharing class RecordType extends Metadata {
        public String type = 'RecordType';
        public String fullName;
        public Boolean active;
        public String businessProcess;
        public String compactLayoutAssignment;
        public String description;
        public String label;
        public MetadataService.RecordTypePicklistValue[] picklistValues;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] businessProcess_type_info = new String[]{'businessProcess','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] compactLayoutAssignment_type_info = new String[]{'compactLayoutAssignment','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','businessProcess','compactLayoutAssignment','description','label','picklistValues'};
    }
    public with sharing class ContactCriteriaBasedSharingRule {
        public String booleanFilter;
        public String contactAccessLevel;
        public String description;
        public String name;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] contactAccessLevel_type_info = new String[]{'contactAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanFilter','contactAccessLevel','description','name'};
    }
    public with sharing class FilterItem {
        public String field;
        public String operation;
        public String value;
        public String valueField;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] operation_type_info = new String[]{'operation','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] valueField_type_info = new String[]{'valueField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','operation','value','valueField'};
    }
    public with sharing class Profile extends Metadata {
        public String type = 'Profile';
        public String fullName;
        public MetadataService.ProfileApplicationVisibility[] applicationVisibilities;
        public MetadataService.ProfileApexClassAccess[] classAccesses;
        public Boolean custom;
        public MetadataService.ProfileCustomPermissions[] customPermissions;
        public String description;
        public MetadataService.ProfileExternalDataSourceAccess[] externalDataSourceAccesses;
        public MetadataService.ProfileFieldLevelSecurity[] fieldPermissions;
        public MetadataService.ProfileLayoutAssignment[] layoutAssignments;
        public MetadataService.ProfileLoginHours loginHours;
        public MetadataService.ProfileLoginIpRange[] loginIpRanges;
        public MetadataService.ProfileObjectPermissions[] objectPermissions;
        public MetadataService.ProfileApexPageAccess[] pageAccesses;
        public MetadataService.ProfileRecordTypeVisibility[] recordTypeVisibilities;
        public MetadataService.ProfileTabVisibility[] tabVisibilities;
        public String userLicense;
        public MetadataService.ProfileUserPermission[] userPermissions;
        private String[] applicationVisibilities_type_info = new String[]{'applicationVisibilities','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] classAccesses_type_info = new String[]{'classAccesses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] custom_type_info = new String[]{'custom','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customPermissions_type_info = new String[]{'customPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalDataSourceAccesses_type_info = new String[]{'externalDataSourceAccesses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fieldPermissions_type_info = new String[]{'fieldPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] layoutAssignments_type_info = new String[]{'layoutAssignments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] loginHours_type_info = new String[]{'loginHours','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] loginIpRanges_type_info = new String[]{'loginIpRanges','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] objectPermissions_type_info = new String[]{'objectPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] pageAccesses_type_info = new String[]{'pageAccesses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] recordTypeVisibilities_type_info = new String[]{'recordTypeVisibilities','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] tabVisibilities_type_info = new String[]{'tabVisibilities','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] userLicense_type_info = new String[]{'userLicense','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] userPermissions_type_info = new String[]{'userPermissions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'applicationVisibilities','classAccesses','custom','customPermissions','description','externalDataSourceAccesses','fieldPermissions','layoutAssignments','loginHours','loginIpRanges','objectPermissions','pageAccesses','recordTypeVisibilities','tabVisibilities','userLicense','userPermissions'};
    }
    public with sharing class ConnectedApp extends Metadata {
        public String type = 'ConnectedApp';
        public String fullName;
        public MetadataService.ConnectedAppAttribute[] attributes;
        public MetadataService.ConnectedAppCanvasConfig canvasConfig;
        public String contactEmail;
        public String contactPhone;
        public String description;
        public String iconUrl;
        public String infoUrl;
        public MetadataService.ConnectedAppIpRange[] ipRanges;
        public String label;
        public String logoUrl;
        public MetadataService.ConnectedAppMobileDetailConfig mobileAppConfig;
        public String mobileStartUrl;
        public MetadataService.ConnectedAppOauthConfig oauthConfig;
        public MetadataService.ConnectedAppSamlConfig samlConfig;
        public String startUrl;
        private String[] attributes_type_info = new String[]{'attributes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] canvasConfig_type_info = new String[]{'canvasConfig','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] contactEmail_type_info = new String[]{'contactEmail','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] contactPhone_type_info = new String[]{'contactPhone','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] iconUrl_type_info = new String[]{'iconUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] infoUrl_type_info = new String[]{'infoUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] ipRanges_type_info = new String[]{'ipRanges','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] logoUrl_type_info = new String[]{'logoUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mobileAppConfig_type_info = new String[]{'mobileAppConfig','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mobileStartUrl_type_info = new String[]{'mobileStartUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] oauthConfig_type_info = new String[]{'oauthConfig','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] samlConfig_type_info = new String[]{'samlConfig','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] startUrl_type_info = new String[]{'startUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'attributes','canvasConfig','contactEmail','contactPhone','description','iconUrl','infoUrl','ipRanges','label','logoUrl','mobileAppConfig','mobileStartUrl','oauthConfig','samlConfig','startUrl'};
    }
    public with sharing class ReportFilter {
        public String booleanFilter;
        public MetadataService.ReportFilterItem[] criteriaItems;
        public String language;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] criteriaItems_type_info = new String[]{'criteriaItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] language_type_info = new String[]{'language','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanFilter','criteriaItems','language'};
    }
    public with sharing class Layout extends Metadata {
        public String type = 'Layout';
        public String fullName;
        public String[] customButtons;
        public MetadataService.CustomConsoleComponents customConsoleComponents;
        public Boolean emailDefault;
        public String[] excludeButtons;
        public MetadataService.FeedLayout feedLayout;
        public String[] headers;
        public MetadataService.LayoutSection[] layoutSections;
        public MetadataService.MiniLayout miniLayout;
        public String[] multilineLayoutFields;
        public MetadataService.QuickActionList quickActionList;
        public MetadataService.RelatedContent relatedContent;
        public MetadataService.RelatedListItem[] relatedLists;
        public String[] relatedObjects;
        public Boolean runAssignmentRulesDefault;
        public Boolean showEmailCheckbox;
        public Boolean showHighlightsPanel;
        public Boolean showInteractionLogPanel;
        public Boolean showKnowledgeComponent;
        public Boolean showRunAssignmentRulesCheckbox;
        public Boolean showSolutionSection;
        public Boolean showSubmitAndAttachButton;
        public MetadataService.SummaryLayout summaryLayout;
        private String[] customButtons_type_info = new String[]{'customButtons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] customConsoleComponents_type_info = new String[]{'customConsoleComponents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailDefault_type_info = new String[]{'emailDefault','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] excludeButtons_type_info = new String[]{'excludeButtons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] feedLayout_type_info = new String[]{'feedLayout','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] headers_type_info = new String[]{'headers','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] layoutSections_type_info = new String[]{'layoutSections','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] miniLayout_type_info = new String[]{'miniLayout','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] multilineLayoutFields_type_info = new String[]{'multilineLayoutFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] quickActionList_type_info = new String[]{'quickActionList','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relatedContent_type_info = new String[]{'relatedContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relatedLists_type_info = new String[]{'relatedLists','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] relatedObjects_type_info = new String[]{'relatedObjects','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] runAssignmentRulesDefault_type_info = new String[]{'runAssignmentRulesDefault','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showEmailCheckbox_type_info = new String[]{'showEmailCheckbox','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showHighlightsPanel_type_info = new String[]{'showHighlightsPanel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showInteractionLogPanel_type_info = new String[]{'showInteractionLogPanel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showKnowledgeComponent_type_info = new String[]{'showKnowledgeComponent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showRunAssignmentRulesCheckbox_type_info = new String[]{'showRunAssignmentRulesCheckbox','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showSolutionSection_type_info = new String[]{'showSolutionSection','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showSubmitAndAttachButton_type_info = new String[]{'showSubmitAndAttachButton','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryLayout_type_info = new String[]{'summaryLayout','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'customButtons','customConsoleComponents','emailDefault','excludeButtons','feedLayout','headers','layoutSections','miniLayout','multilineLayoutFields','quickActionList','relatedContent','relatedLists','relatedObjects','runAssignmentRulesDefault','showEmailCheckbox','showHighlightsPanel','showInteractionLogPanel','showKnowledgeComponent','showRunAssignmentRulesCheckbox','showSolutionSection','showSubmitAndAttachButton','summaryLayout'};
    }
    public with sharing class KeyboardShortcuts {
        public MetadataService.CustomShortcut[] customShortcut;
        public MetadataService.DefaultShortcut[] defaultShortcut;
        private String[] customShortcut_type_info = new String[]{'customShortcut','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] defaultShortcut_type_info = new String[]{'defaultShortcut','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'customShortcut','defaultShortcut'};
    }
    public with sharing class WebLink extends Metadata {
        public String type = 'WebLink';
        public String fullName;
        public String availability;
        public String description;
        public String displayType;
        public String encodingKey;
        public Boolean hasMenubar;
        public Boolean hasScrollbars;
        public Boolean hasToolbar;
        public Integer height;
        public Boolean isResizable;
        public String linkType;
        public String masterLabel;
        public String openType;
        public String page_x;
        public String position;
        public Boolean protected_x;
        public Boolean requireRowSelection;
        public String scontrol;
        public Boolean showsLocation;
        public Boolean showsStatus;
        public String url;
        public Integer width;
        private String[] availability_type_info = new String[]{'availability','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayType_type_info = new String[]{'displayType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] encodingKey_type_info = new String[]{'encodingKey','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hasMenubar_type_info = new String[]{'hasMenubar','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hasScrollbars_type_info = new String[]{'hasScrollbars','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hasToolbar_type_info = new String[]{'hasToolbar','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isResizable_type_info = new String[]{'isResizable','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] linkType_type_info = new String[]{'linkType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] openType_type_info = new String[]{'openType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] position_type_info = new String[]{'position','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] requireRowSelection_type_info = new String[]{'requireRowSelection','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scontrol_type_info = new String[]{'scontrol','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showsLocation_type_info = new String[]{'showsLocation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showsStatus_type_info = new String[]{'showsStatus','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] url_type_info = new String[]{'url','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'availability','description','displayType','encodingKey','hasMenubar','hasScrollbars','hasToolbar','height','isResizable','linkType','masterLabel','openType','page_x','position','protected_x','requireRowSelection','scontrol','showsLocation','showsStatus','url','width'};
    }
    public with sharing class ApprovalStep {
        public Boolean allowDelegate;
        public MetadataService.ApprovalAction approvalActions;
        public MetadataService.ApprovalStepApprover assignedApprover;
        public String description;
        public MetadataService.ApprovalEntryCriteria entryCriteria;
        public String ifCriteriaNotMet;
        public String label;
        public String name;
        public MetadataService.ApprovalStepRejectBehavior rejectBehavior;
        public MetadataService.ApprovalAction rejectionActions;
        private String[] allowDelegate_type_info = new String[]{'allowDelegate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] approvalActions_type_info = new String[]{'approvalActions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assignedApprover_type_info = new String[]{'assignedApprover','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] entryCriteria_type_info = new String[]{'entryCriteria','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] ifCriteriaNotMet_type_info = new String[]{'ifCriteriaNotMet','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] rejectBehavior_type_info = new String[]{'rejectBehavior','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] rejectionActions_type_info = new String[]{'rejectionActions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'allowDelegate','approvalActions','assignedApprover','description','entryCriteria','ifCriteriaNotMet','label','name','rejectBehavior','rejectionActions'};
    }
    public with sharing class ObjectNameCaseValue {
        public String article;
        public String caseType;
        public Boolean plural;
        public String possessive;
        public String value;
        private String[] article_type_info = new String[]{'article','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseType_type_info = new String[]{'caseType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] plural_type_info = new String[]{'plural','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] possessive_type_info = new String[]{'possessive','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'article','caseType','plural','possessive','value'};
    }
    public with sharing class ChannelLayoutItem {
        public String field;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field'};
    }
    public with sharing class upsertMetadataResponse_element {
        public MetadataService.UpsertResult[] result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class CustomDataTypeTranslation {
        public MetadataService.CustomDataTypeComponentTranslation[] components;
        public String customDataTypeName;
        public String description;
        public String label;
        private String[] components_type_info = new String[]{'components','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] customDataTypeName_type_info = new String[]{'customDataTypeName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'components','customDataTypeName','description','label'};
    }
    public with sharing class SiteDotCom extends MetadataWithContent {
        public String type = 'SiteDotCom';
        public String fullName;
        public String content;
        public String label;
        public String siteType;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] siteType_type_info = new String[]{'siteType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'label','siteType'};
    }
    public with sharing class CallOptions_element {
        public String client;
        private String[] client_type_info = new String[]{'client','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'client'};
    }
    public with sharing class AgentConfigAssignments {
        public MetadataService.AgentConfigProfileAssignments profiles;
        public MetadataService.AgentConfigUserAssignments users;
        private String[] profiles_type_info = new String[]{'profiles','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] users_type_info = new String[]{'users','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'profiles','users'};
    }
    public with sharing class createMetadataResponse_element {
        public MetadataService.SaveResult[] result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class CustomFieldTranslation {
        public MetadataService.ObjectNameCaseValue[] caseValues;
        public String gender;
        public String help;
        public String label;
        public MetadataService.LookupFilterTranslation lookupFilter;
        public String name;
        public MetadataService.PicklistValueTranslation[] picklistValues;
        public String relationshipLabel;
        public String startsWith;
        private String[] caseValues_type_info = new String[]{'caseValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] gender_type_info = new String[]{'gender','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] help_type_info = new String[]{'help','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lookupFilter_type_info = new String[]{'lookupFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] relationshipLabel_type_info = new String[]{'relationshipLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] startsWith_type_info = new String[]{'startsWith','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'caseValues','gender','help','label','lookupFilter','name','picklistValues','relationshipLabel','startsWith'};
    }
    public with sharing class CustomObjectOwnerSharingRule {
        public String accessLevel;
        public String description;
        public String name;
        private String[] accessLevel_type_info = new String[]{'accessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accessLevel','description','name'};
    }
    public with sharing class updateMetadata_element {
        public MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'metadata'};
    }
    public with sharing class AnalyticSnapshot extends Metadata {
        public String type = 'AnalyticSnapshot';
        public String fullName;
        public String description;
        public String groupColumn;
        public MetadataService.AnalyticSnapshotMapping[] mappings;
        public String name;
        public String runningUser;
        public String sourceReport;
        public String targetObject;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] groupColumn_type_info = new String[]{'groupColumn','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mappings_type_info = new String[]{'mappings','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] runningUser_type_info = new String[]{'runningUser','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sourceReport_type_info = new String[]{'sourceReport','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] targetObject_type_info = new String[]{'targetObject','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','groupColumn','mappings','name','runningUser','sourceReport','targetObject'};
    }
    public with sharing class LookupFilter {
        public Boolean active;
        public String booleanFilter;
        public String description;
        public String errorMessage;
        public MetadataService.FilterItem[] filterItems;
        public String infoMessage;
        public Boolean isOptional;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] filterItems_type_info = new String[]{'filterItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] infoMessage_type_info = new String[]{'infoMessage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isOptional_type_info = new String[]{'isOptional','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'active','booleanFilter','description','errorMessage','filterItems','infoMessage','isOptional'};
    }
    public with sharing class ScontrolTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class ReportColumn {
        public String[] aggregateTypes;
        public String field;
        public Boolean reverseColors;
        public Boolean showChanges;
        private String[] aggregateTypes_type_info = new String[]{'aggregateTypes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] reverseColors_type_info = new String[]{'reverseColors','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showChanges_type_info = new String[]{'showChanges','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'aggregateTypes','field','reverseColors','showChanges'};
    }
    public with sharing class QuickAction extends Metadata {
        public String type = 'QuickAction';
        public String fullName;
        public String canvas;
        public String description;
        public MetadataService.FieldOverride[] fieldOverrides;
        public Integer height;
        public String icon;
        public Boolean isProtected;
        public String label;
        public String page_x;
        public MetadataService.QuickActionLayout quickActionLayout;
        public String standardLabel;
        public String targetObject;
        public String targetParentField;
        public String targetRecordType;
        public String type_x;
        public Integer width;
        private String[] canvas_type_info = new String[]{'canvas','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fieldOverrides_type_info = new String[]{'fieldOverrides','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] icon_type_info = new String[]{'icon','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isProtected_type_info = new String[]{'isProtected','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] quickActionLayout_type_info = new String[]{'quickActionLayout','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] standardLabel_type_info = new String[]{'standardLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] targetObject_type_info = new String[]{'targetObject','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] targetParentField_type_info = new String[]{'targetParentField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] targetRecordType_type_info = new String[]{'targetRecordType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'canvas','description','fieldOverrides','height','icon','isProtected','label','page_x','quickActionLayout','standardLabel','targetObject','targetParentField','targetRecordType','type_x','width'};
    }
    public with sharing class DefaultShortcut {
        public String action;
        public Boolean active;
        public String keyCommand;
        private String[] action_type_info = new String[]{'action','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] keyCommand_type_info = new String[]{'keyCommand','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'action','active','keyCommand'};
    }
    public with sharing class ApexComponent extends MetadataWithContent {
        public String type = 'ApexComponent';
        public String fullName;
        public String content;
        public Double apiVersion;
        public String description;
        public String label;
        public MetadataService.PackageVersion[] packageVersions;
        private String[] apiVersion_type_info = new String[]{'apiVersion','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] packageVersions_type_info = new String[]{'packageVersions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','https://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'apiVersion','description','label','packageVersions'};
    }
    public with sharing class updateMetadataResponse_element {
        public MetadataService.SaveResult[] result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class BaseSharingRule extends Metadata {
        public String type = 'BaseSharingRule';
        public String fullName;
        public MetadataService.SharedTo sharedTo;
        private String[] sharedTo_type_info = new String[]{'sharedTo','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'sharedTo'};
    }
    public with sharing class WorkflowKnowledgePublish extends WorkflowAction {
        public String type = 'WorkflowKnowledgePublish';
        public String fullName;
        public String action;
        public String description;
        public String label;
        public String language;
        public Boolean protected_x;
        private String[] action_type_info = new String[]{'action','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] language_type_info = new String[]{'language','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'action','description','label','language','protected_x'};
    }
    public with sharing class FlexiPage extends Metadata {
        public String type = 'FlexiPage';
        public String fullName;
        public String description;
        public MetadataService.FlexiPageRegion[] flexiPageRegions;
        public String masterLabel;
        public MetadataService.QuickActionList quickActionList;
        public String type_x;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] flexiPageRegions_type_info = new String[]{'flexiPageRegions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] quickActionList_type_info = new String[]{'quickActionList','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','flexiPageRegions','masterLabel','quickActionList','type_x'};
    }
    public with sharing class ConnectedAppSamlConfig {
        public String acsUrl;
        public String certificate;
        public String encryptionCertificate;
        public String encryptionType;
        public String entityUrl;
        public String issuer;
        public String samlNameIdFormat;
        public String samlSubjectCustomAttr;
        public String samlSubjectType;
        private String[] acsUrl_type_info = new String[]{'acsUrl','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] certificate_type_info = new String[]{'certificate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] encryptionCertificate_type_info = new String[]{'encryptionCertificate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] encryptionType_type_info = new String[]{'encryptionType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] entityUrl_type_info = new String[]{'entityUrl','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] issuer_type_info = new String[]{'issuer','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] samlNameIdFormat_type_info = new String[]{'samlNameIdFormat','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] samlSubjectCustomAttr_type_info = new String[]{'samlSubjectCustomAttr','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] samlSubjectType_type_info = new String[]{'samlSubjectType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'acsUrl','certificate','encryptionCertificate','encryptionType','entityUrl','issuer','samlNameIdFormat','samlSubjectCustomAttr','samlSubjectType'};
    }
    public with sharing class FlowWait {
        public MetadataService.FlowConnector defaultConnector;
        public String defaultConnectorLabel;
        public MetadataService.FlowConnector faultConnector;
        public MetadataService.FlowWaitEvent[] waitEvents;
        private String[] defaultConnector_type_info = new String[]{'defaultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultConnectorLabel_type_info = new String[]{'defaultConnectorLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] faultConnector_type_info = new String[]{'faultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] waitEvents_type_info = new String[]{'waitEvents','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'defaultConnector','defaultConnectorLabel','faultConnector','waitEvents'};
    }
    public with sharing class createMetadata_element {
        public MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'metadata'};
    }
    public with sharing class Workflow extends Metadata {
        public String type = 'Workflow';
        public String fullName;
        public MetadataService.WorkflowAlert[] alerts;
        public MetadataService.WorkflowFieldUpdate[] fieldUpdates;
        public MetadataService.WorkflowFlowAction[] flowActions;
        public MetadataService.WorkflowKnowledgePublish[] knowledgePublishes;
        public MetadataService.WorkflowOutboundMessage[] outboundMessages;
        public MetadataService.WorkflowRule[] rules;
        public MetadataService.WorkflowSend[] send;
        public MetadataService.WorkflowTask[] tasks;
        private String[] alerts_type_info = new String[]{'alerts','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fieldUpdates_type_info = new String[]{'fieldUpdates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] flowActions_type_info = new String[]{'flowActions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] knowledgePublishes_type_info = new String[]{'knowledgePublishes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] outboundMessages_type_info = new String[]{'outboundMessages','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] rules_type_info = new String[]{'rules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] send_type_info = new String[]{'send','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] tasks_type_info = new String[]{'tasks','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'alerts','fieldUpdates','flowActions','knowledgePublishes','outboundMessages','rules','send','tasks'};
    }
    public with sharing class AddressSettings extends Metadata {
        public String type = 'AddressSettings';
        public String fullName;
        public MetadataService.CountriesAndStates countriesAndStates;
        private String[] countriesAndStates_type_info = new String[]{'countriesAndStates','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'countriesAndStates'};
    }
    public with sharing class FlowChoice {
        public String choiceText;
        public String dataType;
        public MetadataService.FlowChoiceUserInput userInput;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] choiceText_type_info = new String[]{'choiceText','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] dataType_type_info = new String[]{'dataType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] userInput_type_info = new String[]{'userInput','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'choiceText','dataType','userInput','value'};
    }
    public with sharing class ProfileExternalDataSourceAccess {
        public Boolean enabled;
        public String externalDataSource;
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] externalDataSource_type_info = new String[]{'externalDataSource','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enabled','externalDataSource'};
    }
    public with sharing class FeedLayoutComponent {
        public String componentType;
        public Integer height;
        public String page_x;
        private String[] componentType_type_info = new String[]{'componentType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'componentType','height','page_x'};
    }
    public with sharing class Territory2Settings extends Metadata {
        public String type = 'Territory2Settings';
        public String fullName;
        public String defaultAccountAccessLevel;
        public String defaultCaseAccessLevel;
        public String defaultContactAccessLevel;
        public String defaultOpportunityAccessLevel;
        private String[] defaultAccountAccessLevel_type_info = new String[]{'defaultAccountAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultCaseAccessLevel_type_info = new String[]{'defaultCaseAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultContactAccessLevel_type_info = new String[]{'defaultContactAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultOpportunityAccessLevel_type_info = new String[]{'defaultOpportunityAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'defaultAccountAccessLevel','defaultCaseAccessLevel','defaultContactAccessLevel','defaultOpportunityAccessLevel'};
    }
    public with sharing class CallCenterItem {
        public String label;
        public String name;
        public String value;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name','value'};
    }
    public with sharing class ApprovalAction {
        public MetadataService.WorkflowActionReference[] action;
        private String[] action_type_info = new String[]{'action','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'action'};
    }
    public with sharing class FlowStep {
        public MetadataService.FlowConnector[] connectors;
        private String[] connectors_type_info = new String[]{'connectors','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'connectors'};
    }
    public with sharing class ProfileObjectPermissions {
        public Boolean allowCreate;
        public Boolean allowDelete;
        public Boolean allowEdit;
        public Boolean allowRead;
        public Boolean modifyAllRecords;
        public String object_x;
        public Boolean viewAllRecords;
        private String[] allowCreate_type_info = new String[]{'allowCreate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowDelete_type_info = new String[]{'allowDelete','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowEdit_type_info = new String[]{'allowEdit','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowRead_type_info = new String[]{'allowRead','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] modifyAllRecords_type_info = new String[]{'modifyAllRecords','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] viewAllRecords_type_info = new String[]{'viewAllRecords','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'allowCreate','allowDelete','allowEdit','allowRead','modifyAllRecords','object_x','viewAllRecords'};
    }
    public with sharing class SecuritySettings extends Metadata {
        public String type = 'SecuritySettings';
        public String fullName;
        public MetadataService.NetworkAccess networkAccess;
        public MetadataService.PasswordPolicies passwordPolicies;
        public MetadataService.SessionSettings sessionSettings;
        private String[] networkAccess_type_info = new String[]{'networkAccess','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] passwordPolicies_type_info = new String[]{'passwordPolicies','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sessionSettings_type_info = new String[]{'sessionSettings','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'networkAccess','passwordPolicies','sessionSettings'};
    }
    public with sharing class WorkflowTimeTrigger {
        public MetadataService.WorkflowActionReference[] actions;
        public String offsetFromField;
        public String timeLength;
        public String workflowTimeTriggerUnit;
        private String[] actions_type_info = new String[]{'actions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] offsetFromField_type_info = new String[]{'offsetFromField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] timeLength_type_info = new String[]{'timeLength','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] workflowTimeTriggerUnit_type_info = new String[]{'workflowTimeTriggerUnit','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'actions','offsetFromField','timeLength','workflowTimeTriggerUnit'};
    }
    public with sharing class retrieve_element {
        public MetadataService.RetrieveRequest retrieveRequest;
        private String[] retrieveRequest_type_info = new String[]{'retrieveRequest','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'retrieveRequest'};
    }
    public with sharing class KnowledgeLanguage {
        public Boolean active;
        public String defaultAssignee;
        public String defaultAssigneeType;
        public String defaultReviewer;
        public String defaultReviewerType;
        public String name;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultAssignee_type_info = new String[]{'defaultAssignee','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultAssigneeType_type_info = new String[]{'defaultAssigneeType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultReviewer_type_info = new String[]{'defaultReviewer','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultReviewerType_type_info = new String[]{'defaultReviewerType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'active','defaultAssignee','defaultAssigneeType','defaultReviewer','defaultReviewerType','name'};
    }
    public with sharing class PermissionSetExternalDataSourceAccess {
        public Boolean enabled;
        public String externalDataSource;
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] externalDataSource_type_info = new String[]{'externalDataSource','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enabled','externalDataSource'};
    }
    public with sharing class DescribeMetadataObject {
        public String[] childXmlNames;
        public String directoryName;
        public Boolean inFolder;
        public Boolean metaFile;
        public String suffix;
        public String xmlName;
        private String[] childXmlNames_type_info = new String[]{'childXmlNames','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] directoryName_type_info = new String[]{'directoryName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] inFolder_type_info = new String[]{'inFolder','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] metaFile_type_info = new String[]{'metaFile','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] suffix_type_info = new String[]{'suffix','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] xmlName_type_info = new String[]{'xmlName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'childXmlNames','directoryName','inFolder','metaFile','suffix','xmlName'};
    }
    public with sharing class LiveChatButtonSkills {
        public String[] skill;
        private String[] skill_type_info = new String[]{'skill','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'skill'};
    }
    public with sharing class LayoutColumn {
        public MetadataService.LayoutItem[] layoutItems;
        public String reserved;
        private String[] layoutItems_type_info = new String[]{'layoutItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] reserved_type_info = new String[]{'reserved','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'layoutItems','reserved'};
    }
    public with sharing class PermissionSetTabSetting {
        public String tab;
        public String visibility;
        private String[] tab_type_info = new String[]{'tab','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visibility_type_info = new String[]{'visibility','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'tab','visibility'};
    }
    public with sharing class SkillUserAssignments {
        public String[] user_x;
        private String[] user_x_type_info = new String[]{'user','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'user_x'};
    }
    public with sharing class PostTemplate extends Metadata {
        public String type = 'PostTemplate';
        public String fullName;
        public Boolean default_x;
        public String description;
        public String[] fields;
        public String label;
        private String[] default_x_type_info = new String[]{'default','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'default_x','description','fields','label'};
    }
    public with sharing class RelatedContentItem {
        public MetadataService.LayoutItem layoutItem;
        private String[] layoutItem_type_info = new String[]{'layoutItem','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'layoutItem'};
    }
    public with sharing class FieldValue {
        public String name;
        public String value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class AuthProvider extends Metadata {
        public String type = 'AuthProvider';
        public String fullName;
        public String authorizeUrl;
        public String consumerKey;
        public String consumerSecret;
        public String defaultScopes;
        public String errorUrl;
        public String executionUser;
        public String friendlyName;
        public String iconUrl;
        public String idTokenIssuer;
        public Boolean includeOrgIdInIdentifier;
        public String portal;
        public String providerType;
        public String registrationHandler;
        public Boolean sendAccessTokenInHeader;
        public Boolean sendClientCredentialsInHeader;
        public String tokenUrl;
        public String userInfoUrl;
        private String[] authorizeUrl_type_info = new String[]{'authorizeUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] consumerKey_type_info = new String[]{'consumerKey','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] consumerSecret_type_info = new String[]{'consumerSecret','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] defaultScopes_type_info = new String[]{'defaultScopes','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] errorUrl_type_info = new String[]{'errorUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] executionUser_type_info = new String[]{'executionUser','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] friendlyName_type_info = new String[]{'friendlyName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] iconUrl_type_info = new String[]{'iconUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] idTokenIssuer_type_info = new String[]{'idTokenIssuer','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] includeOrgIdInIdentifier_type_info = new String[]{'includeOrgIdInIdentifier','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] portal_type_info = new String[]{'portal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] providerType_type_info = new String[]{'providerType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] registrationHandler_type_info = new String[]{'registrationHandler','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sendAccessTokenInHeader_type_info = new String[]{'sendAccessTokenInHeader','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sendClientCredentialsInHeader_type_info = new String[]{'sendClientCredentialsInHeader','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] tokenUrl_type_info = new String[]{'tokenUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] userInfoUrl_type_info = new String[]{'userInfoUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'authorizeUrl','consumerKey','consumerSecret','defaultScopes','errorUrl','executionUser','friendlyName','iconUrl','idTokenIssuer','includeOrgIdInIdentifier','portal','providerType','registrationHandler','sendAccessTokenInHeader','sendClientCredentialsInHeader','tokenUrl','userInfoUrl'};
    }
    public with sharing class ReputationLevel {
        public MetadataService.ReputationBranding branding;
        public String label;
        public Double lowerThreshold;
        private String[] branding_type_info = new String[]{'branding','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lowerThreshold_type_info = new String[]{'lowerThreshold','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'branding','label','lowerThreshold'};
    }
    public with sharing class WorkflowTask extends WorkflowAction {
        public String type = 'WorkflowTask';
        public String fullName;
        public String assignedTo;
        public String assignedToType;
        public String description;
        public Integer dueDateOffset;
        public Boolean notifyAssignee;
        public String offsetFromField;
        public String priority;
        public Boolean protected_x;
        public String status;
        public String subject;
        private String[] assignedTo_type_info = new String[]{'assignedTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assignedToType_type_info = new String[]{'assignedToType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] dueDateOffset_type_info = new String[]{'dueDateOffset','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] notifyAssignee_type_info = new String[]{'notifyAssignee','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] offsetFromField_type_info = new String[]{'offsetFromField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] priority_type_info = new String[]{'priority','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] status_type_info = new String[]{'status','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] subject_type_info = new String[]{'subject','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'assignedTo','assignedToType','description','dueDateOffset','notifyAssignee','offsetFromField','priority','protected_x','status','subject'};
    }
    public with sharing class NextAutomatedApprover {
        public Boolean useApproverFieldOfRecordOwner;
        public String userHierarchyField;
        private String[] useApproverFieldOfRecordOwner_type_info = new String[]{'useApproverFieldOfRecordOwner','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] userHierarchyField_type_info = new String[]{'userHierarchyField','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'useApproverFieldOfRecordOwner','userHierarchyField'};
    }
    public with sharing class ChannelLayout {
        public String[] enabledChannels;
        public String label;
        public MetadataService.ChannelLayoutItem[] layoutItems;
        private String[] enabledChannels_type_info = new String[]{'enabledChannels','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] layoutItems_type_info = new String[]{'layoutItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enabledChannels','label','layoutItems'};
    }
    public with sharing class readMetadata_element {
        public String type_x;
        public String[] fullNames;
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fullNames_type_info = new String[]{'fullNames','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','fullNames'};
    }
    public with sharing class ReportAggregateReference {
        public String aggregate;
        private String[] aggregate_type_info = new String[]{'aggregate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'aggregate'};
    }
    public interface IReadResult {
        MetadataService.Metadata[] getRecords();
    }
    public interface IReadResponseElement {
        IReadResult getResult();
    }
    public with sharing class ReadWorkflowRuleResult implements IReadResult {
        public MetadataService.WorkflowRule[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowRuleResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowRuleResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadSamlSsoConfigResult implements IReadResult {
        public MetadataService.SamlSsoConfig[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readSamlSsoConfigResponse_element implements IReadResponseElement {
        public MetadataService.ReadSamlSsoConfigResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomLabelResult implements IReadResult {
        public MetadataService.CustomLabel[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomLabelResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomLabelResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadBusinessHoursEntryResult implements IReadResult {
        public MetadataService.BusinessHoursEntry[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readBusinessHoursEntryResponse_element implements IReadResponseElement {
        public MetadataService.ReadBusinessHoursEntryResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadMobileSettingsResult implements IReadResult {
        public MetadataService.MobileSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readMobileSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadMobileSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadChatterAnswersSettingsResult implements IReadResult {
        public MetadataService.ChatterAnswersSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readChatterAnswersSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadChatterAnswersSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadSharingRulesResult implements IReadResult {
        public MetadataService.SharingRules[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readSharingRulesResponse_element implements IReadResponseElement {
        public MetadataService.ReadSharingRulesResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadPortalResult implements IReadResult {
        public MetadataService.Portal[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readPortalResponse_element implements IReadResponseElement {
        public MetadataService.ReadPortalResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadSkillResult implements IReadResult {
        public MetadataService.Skill[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readSkillResponse_element implements IReadResponseElement {
        public MetadataService.ReadSkillResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadEscalationRulesResult implements IReadResult {
        public MetadataService.EscalationRules[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readEscalationRulesResponse_element implements IReadResponseElement {
        public MetadataService.ReadEscalationRulesResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWorkflowAlertResult implements IReadResult {
        public MetadataService.WorkflowAlert[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowAlertResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowAlertResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomDataTypeResult implements IReadResult {
        public MetadataService.CustomDataType[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomDataTypeResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomDataTypeResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadExternalDataSourceResult implements IReadResult {
        public MetadataService.ExternalDataSource[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readExternalDataSourceResponse_element implements IReadResponseElement {
        public MetadataService.ReadExternalDataSourceResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadXOrgHubResult implements IReadResult {
        public MetadataService.XOrgHub[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readXOrgHubResponse_element implements IReadResponseElement {
        public MetadataService.ReadXOrgHubResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadEntitlementProcessResult implements IReadResult {
        public MetadataService.EntitlementProcess[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readEntitlementProcessResponse_element implements IReadResponseElement {
        public MetadataService.ReadEntitlementProcessResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadRecordTypeResult implements IReadResult {
        public MetadataService.RecordType[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readRecordTypeResponse_element implements IReadResponseElement {
        public MetadataService.ReadRecordTypeResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadScontrolResult implements IReadResult {
        public MetadataService.Scontrol[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readScontrolResponse_element implements IReadResponseElement {
        public MetadataService.ReadScontrolResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadDataCategoryGroupResult implements IReadResult {
        public MetadataService.DataCategoryGroup[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readDataCategoryGroupResponse_element implements IReadResponseElement {
        public MetadataService.ReadDataCategoryGroupResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadValidationRuleResult implements IReadResult {
        public MetadataService.ValidationRule[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readValidationRuleResponse_element implements IReadResponseElement {
        public MetadataService.ReadValidationRuleResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAuraDefinitionBundleResult implements IReadResult {
        public MetadataService.AuraDefinitionBundle[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAuraDefinitionBundleResponse_element implements IReadResponseElement {
        public MetadataService.ReadAuraDefinitionBundleResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadProfileResult implements IReadResult {
        public MetadataService.Profile[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readProfileResponse_element implements IReadResponseElement {
        public MetadataService.ReadProfileResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadIdeasSettingsResult implements IReadResult {
        public MetadataService.IdeasSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readIdeasSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadIdeasSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadConnectedAppResult implements IReadResult {
        public MetadataService.ConnectedApp[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readConnectedAppResponse_element implements IReadResponseElement {
        public MetadataService.ReadConnectedAppResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadApexPageResult implements IReadResult {
        public MetadataService.ApexPage[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readApexPageResponse_element implements IReadResponseElement {
        public MetadataService.ReadApexPageResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadLiveAgentSettingsResult implements IReadResult {
        public MetadataService.LiveAgentSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readLiveAgentSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadLiveAgentSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadProductSettingsResult implements IReadResult {
        public MetadataService.ProductSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readProductSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadProductSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadOpportunitySettingsResult implements IReadResult {
        public MetadataService.OpportunitySettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readOpportunitySettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadOpportunitySettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadLiveChatDeploymentResult implements IReadResult {
        public MetadataService.LiveChatDeployment[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readLiveChatDeploymentResponse_element implements IReadResponseElement {
        public MetadataService.ReadLiveChatDeploymentResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadActivitiesSettingsResult implements IReadResult {
        public MetadataService.ActivitiesSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readActivitiesSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadActivitiesSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadLayoutResult implements IReadResult {
        public MetadataService.Layout[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readLayoutResponse_element implements IReadResponseElement {
        public MetadataService.ReadLayoutResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWebLinkResult implements IReadResult {
        public MetadataService.WebLink[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWebLinkResponse_element implements IReadResponseElement {
        public MetadataService.ReadWebLinkResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomPermissionResult implements IReadResult {
        public MetadataService.CustomPermission[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomPermissionResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomPermissionResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadSiteDotComResult implements IReadResult {
        public MetadataService.SiteDotCom[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readSiteDotComResponse_element implements IReadResponseElement {
        public MetadataService.ReadSiteDotComResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCompanySettingsResult implements IReadResult {
        public MetadataService.CompanySettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCompanySettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadCompanySettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadHomePageLayoutResult implements IReadResult {
        public MetadataService.HomePageLayout[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readHomePageLayoutResponse_element implements IReadResponseElement {
        public MetadataService.ReadHomePageLayoutResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadDashboardResult implements IReadResult {
        public MetadataService.Dashboard[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readDashboardResponse_element implements IReadResponseElement {
        public MetadataService.ReadDashboardResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAssignmentRulesResult implements IReadResult {
        public MetadataService.AssignmentRules[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAssignmentRulesResponse_element implements IReadResponseElement {
        public MetadataService.ReadAssignmentRulesResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadEmailFolderResult implements IReadResult {
        public MetadataService.EmailFolder[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readEmailFolderResponse_element implements IReadResponseElement {
        public MetadataService.ReadEmailFolderResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomMetadataResult implements IReadResult {
        public MetadataService.CustomMetadata[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomMetadataResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomMetadataResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAnalyticSnapshotResult implements IReadResult {
        public MetadataService.AnalyticSnapshot[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAnalyticSnapshotResponse_element implements IReadResponseElement {
        public MetadataService.ReadAnalyticSnapshotResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadVisualizationPluginResult implements IReadResult {
        public MetadataService.VisualizationPlugin[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readVisualizationPluginResponse_element implements IReadResponseElement {
        public MetadataService.ReadVisualizationPluginResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadEscalationRuleResult implements IReadResult {
        public MetadataService.EscalationRule[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readEscalationRuleResponse_element implements IReadResponseElement {
        public MetadataService.ReadEscalationRuleResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomSiteResult implements IReadResult {
        public MetadataService.CustomSite[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomSiteResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomSiteResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadMarketingActionSettingsResult implements IReadResult {
        public MetadataService.MarketingActionSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readMarketingActionSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadMarketingActionSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadGroupResult implements IReadResult {
        public MetadataService.Group_x[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readGroupResponse_element implements IReadResponseElement {
        public MetadataService.ReadGroupResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadReportTypeResult implements IReadResult {
        public MetadataService.ReportType[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readReportTypeResponse_element implements IReadResponseElement {
        public MetadataService.ReadReportTypeResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadQuickActionResult implements IReadResult {
        public MetadataService.QuickAction[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readQuickActionResponse_element implements IReadResponseElement {
        public MetadataService.ReadQuickActionResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomPageWebLinkResult implements IReadResult {
        public MetadataService.CustomPageWebLink[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomPageWebLinkResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomPageWebLinkResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadApexComponentResult implements IReadResult {
        public MetadataService.ApexComponent[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readApexComponentResponse_element implements IReadResponseElement {
        public MetadataService.ReadApexComponentResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadBaseSharingRuleResult implements IReadResult {
        public MetadataService.BaseSharingRule[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readBaseSharingRuleResponse_element implements IReadResponseElement {
        public MetadataService.ReadBaseSharingRuleResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWorkflowKnowledgePublishResult implements IReadResult {
        public MetadataService.WorkflowKnowledgePublish[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowKnowledgePublishResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowKnowledgePublishResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadEntitlementTemplateResult implements IReadResult {
        public MetadataService.EntitlementTemplate[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readEntitlementTemplateResponse_element implements IReadResponseElement {
        public MetadataService.ReadEntitlementTemplateResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadFlexiPageResult implements IReadResult {
        public MetadataService.FlexiPage[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readFlexiPageResponse_element implements IReadResponseElement {
        public MetadataService.ReadFlexiPageResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWorkflowActionResult implements IReadResult {
        public MetadataService.WorkflowAction[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowActionResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowActionResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWorkflowResult implements IReadResult {
        public MetadataService.Workflow[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAddressSettingsResult implements IReadResult {
        public MetadataService.AddressSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAddressSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadAddressSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadContractSettingsResult implements IReadResult {
        public MetadataService.ContractSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readContractSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadContractSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadDashboardFolderResult implements IReadResult {
        public MetadataService.DashboardFolder[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readDashboardFolderResponse_element implements IReadResponseElement {
        public MetadataService.ReadDashboardFolderResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadTerritory2SettingsResult implements IReadResult {
        public MetadataService.Territory2Settings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readTerritory2SettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadTerritory2SettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomObjectResult implements IReadResult {
        public MetadataService.CustomObject[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomObjectResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomObjectResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadTranslationsResult implements IReadResult {
        public MetadataService.Translations[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readTranslationsResponse_element implements IReadResponseElement {
        public MetadataService.ReadTranslationsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadRoleOrTerritoryResult implements IReadResult {
        public MetadataService.RoleOrTerritory[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readRoleOrTerritoryResponse_element implements IReadResponseElement {
        public MetadataService.ReadRoleOrTerritoryResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadApexTriggerResult implements IReadResult {
        public MetadataService.ApexTrigger[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readApexTriggerResponse_element implements IReadResponseElement {
        public MetadataService.ReadApexTriggerResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomLabelsResult implements IReadResult {
        public MetadataService.CustomLabels[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomLabelsResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomLabelsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadSecuritySettingsResult implements IReadResult {
        public MetadataService.SecuritySettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readSecuritySettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadSecuritySettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCallCenterResult implements IReadResult {
        public MetadataService.CallCenter[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCallCenterResponse_element implements IReadResponseElement {
        public MetadataService.ReadCallCenterResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadPicklistValueResult implements IReadResult {
        public MetadataService.PicklistValue[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readPicklistValueResponse_element implements IReadResponseElement {
        public MetadataService.ReadPicklistValueResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadRemoteSiteSettingResult implements IReadResult {
        public MetadataService.RemoteSiteSetting[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readRemoteSiteSettingResponse_element implements IReadResponseElement {
        public MetadataService.ReadRemoteSiteSettingResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWorkflowSendResult implements IReadResult {
        public MetadataService.WorkflowSend[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowSendResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowSendResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadTerritory2TypeResult implements IReadResult {
        public MetadataService.Territory2Type[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readTerritory2TypeResponse_element implements IReadResponseElement {
        public MetadataService.ReadTerritory2TypeResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadQuoteSettingsResult implements IReadResult {
        public MetadataService.QuoteSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readQuoteSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadQuoteSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadSynonymDictionaryResult implements IReadResult {
        public MetadataService.SynonymDictionary[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readSynonymDictionaryResponse_element implements IReadResponseElement {
        public MetadataService.ReadSynonymDictionaryResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWorkflowOutboundMessageResult implements IReadResult {
        public MetadataService.WorkflowOutboundMessage[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowOutboundMessageResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowOutboundMessageResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadPostTemplateResult implements IReadResult {
        public MetadataService.PostTemplate[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readPostTemplateResponse_element implements IReadResponseElement {
        public MetadataService.ReadPostTemplateResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWorkflowFieldUpdateResult implements IReadResult {
        public MetadataService.WorkflowFieldUpdate[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowFieldUpdateResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowFieldUpdateResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomTabResult implements IReadResult {
        public MetadataService.CustomTab[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomTabResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomTabResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadLetterheadResult implements IReadResult {
        public MetadataService.Letterhead[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readLetterheadResponse_element implements IReadResponseElement {
        public MetadataService.ReadLetterheadResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadInstalledPackageResult implements IReadResult {
        public MetadataService.InstalledPackage[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readInstalledPackageResponse_element implements IReadResponseElement {
        public MetadataService.ReadInstalledPackageResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadQueueResult implements IReadResult {
        public MetadataService.Queue[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readQueueResponse_element implements IReadResponseElement {
        public MetadataService.ReadQueueResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAuthProviderResult implements IReadResult {
        public MetadataService.AuthProvider[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAuthProviderResponse_element implements IReadResponseElement {
        public MetadataService.ReadAuthProviderResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadEntitlementSettingsResult implements IReadResult {
        public MetadataService.EntitlementSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readEntitlementSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadEntitlementSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadDocumentFolderResult implements IReadResult {
        public MetadataService.DocumentFolder[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readDocumentFolderResponse_element implements IReadResponseElement {
        public MetadataService.ReadDocumentFolderResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomFieldResult implements IReadResult {
        public MetadataService.CustomField[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomFieldResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomFieldResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadWorkflowTaskResult implements IReadResult {
        public MetadataService.WorkflowTask[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readWorkflowTaskResponse_element implements IReadResponseElement {
        public MetadataService.ReadWorkflowTaskResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCorsWhitelistOriginResult implements IReadResult {
        public MetadataService.CorsWhitelistOrigin[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCorsWhitelistOriginResponse_element implements IReadResponseElement {
        public MetadataService.ReadCorsWhitelistOriginResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadStaticResourceResult implements IReadResult {
        public MetadataService.StaticResource[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readStaticResourceResponse_element implements IReadResponseElement {
        public MetadataService.ReadStaticResourceResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadEmailTemplateResult implements IReadResult {
        public MetadataService.EmailTemplate[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readEmailTemplateResponse_element implements IReadResponseElement {
        public MetadataService.ReadEmailTemplateResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadSharingReasonResult implements IReadResult {
        public MetadataService.SharingReason[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readSharingReasonResponse_element implements IReadResponseElement {
        public MetadataService.ReadSharingReasonResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadLiveChatButtonResult implements IReadResult {
        public MetadataService.LiveChatButton[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readLiveChatButtonResponse_element implements IReadResponseElement {
        public MetadataService.ReadLiveChatButtonResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadNetworkResult implements IReadResult {
        public MetadataService.Network[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readNetworkResponse_element implements IReadResponseElement {
        public MetadataService.ReadNetworkResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadApprovalProcessResult implements IReadResult {
        public MetadataService.ApprovalProcess[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readApprovalProcessResponse_element implements IReadResponseElement {
        public MetadataService.ReadApprovalProcessResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadMilestoneTypeResult implements IReadResult {
        public MetadataService.MilestoneType[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readMilestoneTypeResponse_element implements IReadResponseElement {
        public MetadataService.ReadMilestoneTypeResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAssignmentRuleResult implements IReadResult {
        public MetadataService.AssignmentRule[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAssignmentRuleResponse_element implements IReadResponseElement {
        public MetadataService.ReadAssignmentRuleResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCompactLayoutResult implements IReadResult {
        public MetadataService.CompactLayout[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCompactLayoutResponse_element implements IReadResponseElement {
        public MetadataService.ReadCompactLayoutResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadLiveChatAgentConfigResult implements IReadResult {
        public MetadataService.LiveChatAgentConfig[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readLiveChatAgentConfigResponse_element implements IReadResponseElement {
        public MetadataService.ReadLiveChatAgentConfigResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAccountSettingsResult implements IReadResult {
        public MetadataService.AccountSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAccountSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadAccountSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadBusinessProcessResult implements IReadResult {
        public MetadataService.BusinessProcess[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readBusinessProcessResponse_element implements IReadResponseElement {
        public MetadataService.ReadBusinessProcessResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAutoResponseRuleResult implements IReadResult {
        public MetadataService.AutoResponseRule[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAutoResponseRuleResponse_element implements IReadResponseElement {
        public MetadataService.ReadAutoResponseRuleResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadFlowResult implements IReadResult {
        public MetadataService.Flow[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readFlowResponse_element implements IReadResponseElement {
        public MetadataService.ReadFlowResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadPermissionSetResult implements IReadResult {
        public MetadataService.PermissionSet[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readPermissionSetResponse_element implements IReadResponseElement {
        public MetadataService.ReadPermissionSetResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadManagedTopicsResult implements IReadResult {
        public MetadataService.ManagedTopics[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readManagedTopicsResponse_element implements IReadResponseElement {
        public MetadataService.ReadManagedTopicsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadForecastingSettingsResult implements IReadResult {
        public MetadataService.ForecastingSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readForecastingSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadForecastingSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadBusinessHoursSettingsResult implements IReadResult {
        public MetadataService.BusinessHoursSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readBusinessHoursSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadBusinessHoursSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadReportResult implements IReadResult {
        public MetadataService.Report[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readReportResponse_element implements IReadResponseElement {
        public MetadataService.ReadReportResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAppMenuResult implements IReadResult {
        public MetadataService.AppMenu[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAppMenuResponse_element implements IReadResponseElement {
        public MetadataService.ReadAppMenuResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadListViewResult implements IReadResult {
        public MetadataService.ListView[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readListViewResponse_element implements IReadResponseElement {
        public MetadataService.ReadListViewResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadOrderSettingsResult implements IReadResult {
        public MetadataService.OrderSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readOrderSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadOrderSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomObjectTranslationResult implements IReadResult {
        public MetadataService.CustomObjectTranslation[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomObjectTranslationResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomObjectTranslationResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadKnowledgeSettingsResult implements IReadResult {
        public MetadataService.KnowledgeSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readKnowledgeSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadKnowledgeSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomApplicationResult implements IReadResult {
        public MetadataService.CustomApplication[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomApplicationResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomApplicationResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCaseSettingsResult implements IReadResult {
        public MetadataService.CaseSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCaseSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadCaseSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadNameSettingsResult implements IReadResult {
        public MetadataService.NameSettings[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readNameSettingsResponse_element implements IReadResponseElement {
        public MetadataService.ReadNameSettingsResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadApexClassResult implements IReadResult {
        public MetadataService.ApexClass[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readApexClassResponse_element implements IReadResponseElement {
        public MetadataService.ReadApexClassResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadPackageResult implements IReadResult {
        public MetadataService.Package_x[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readPackageResponse_element implements IReadResponseElement {
        public MetadataService.ReadPackageResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadTerritory2Result implements IReadResult {
        public MetadataService.Territory2[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readTerritory2Response_element implements IReadResponseElement {
        public MetadataService.ReadTerritory2Result result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCommunityResult implements IReadResult {
        public MetadataService.Community[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCommunityResponse_element implements IReadResponseElement {
        public MetadataService.ReadCommunityResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadDocumentResult implements IReadResult {
        public MetadataService.Document[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readDocumentResponse_element implements IReadResponseElement {
        public MetadataService.ReadDocumentResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadAutoResponseRulesResult implements IReadResult {
        public MetadataService.AutoResponseRules[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readAutoResponseRulesResponse_element implements IReadResponseElement {
        public MetadataService.ReadAutoResponseRulesResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadFolderResult implements IReadResult {
        public MetadataService.Folder[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readFolderResponse_element implements IReadResponseElement {
        public MetadataService.ReadFolderResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadTerritory2ModelResult implements IReadResult {
        public MetadataService.Territory2Model[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readTerritory2ModelResponse_element implements IReadResponseElement {
        public MetadataService.ReadTerritory2ModelResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadReportFolderResult implements IReadResult {
        public MetadataService.ReportFolder[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readReportFolderResponse_element implements IReadResponseElement {
        public MetadataService.ReadReportFolderResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadCustomApplicationComponentResult implements IReadResult {
        public MetadataService.CustomApplicationComponent[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readCustomApplicationComponentResponse_element implements IReadResponseElement {
        public MetadataService.ReadCustomApplicationComponentResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadFieldSetResult implements IReadResult {
        public MetadataService.FieldSet[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readFieldSetResponse_element implements IReadResponseElement {
        public MetadataService.ReadFieldSetResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadSharingSetResult implements IReadResult {
        public MetadataService.SharingSet[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readSharingSetResponse_element implements IReadResponseElement {
        public MetadataService.ReadSharingSetResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadHomePageComponentResult implements IReadResult {
        public MetadataService.HomePageComponent[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class readHomePageComponentResponse_element implements IReadResponseElement {
        public MetadataService.ReadHomePageComponentResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReadResult {
        public MetadataService.Metadata[] records;
        private String[] records_type_info = new String[]{'records','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public with sharing class ApprovalProcess extends Metadata {
        public String type = 'ApprovalProcess';
        public String fullName;
        public Boolean active;
        public Boolean allowRecall;
        public MetadataService.ApprovalSubmitter[] allowedSubmitters;
        public MetadataService.ApprovalPageField approvalPageFields;
        public MetadataService.ApprovalStep[] approvalStep;
        public String description;
        public String emailTemplate;
        public Boolean enableMobileDeviceAccess;
        public MetadataService.ApprovalEntryCriteria entryCriteria;
        public MetadataService.ApprovalAction finalApprovalActions;
        public Boolean finalApprovalRecordLock;
        public MetadataService.ApprovalAction finalRejectionActions;
        public Boolean finalRejectionRecordLock;
        public MetadataService.ApprovalAction initialSubmissionActions;
        public String label;
        public MetadataService.NextAutomatedApprover nextAutomatedApprover;
        public String postTemplate;
        public MetadataService.ApprovalAction recallActions;
        public String recordEditability;
        public Boolean showApprovalHistory;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] allowRecall_type_info = new String[]{'allowRecall','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowedSubmitters_type_info = new String[]{'allowedSubmitters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] approvalPageFields_type_info = new String[]{'approvalPageFields','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] approvalStep_type_info = new String[]{'approvalStep','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailTemplate_type_info = new String[]{'emailTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableMobileDeviceAccess_type_info = new String[]{'enableMobileDeviceAccess','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] entryCriteria_type_info = new String[]{'entryCriteria','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] finalApprovalActions_type_info = new String[]{'finalApprovalActions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] finalApprovalRecordLock_type_info = new String[]{'finalApprovalRecordLock','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] finalRejectionActions_type_info = new String[]{'finalRejectionActions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] finalRejectionRecordLock_type_info = new String[]{'finalRejectionRecordLock','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] initialSubmissionActions_type_info = new String[]{'initialSubmissionActions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] nextAutomatedApprover_type_info = new String[]{'nextAutomatedApprover','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] postTemplate_type_info = new String[]{'postTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recallActions_type_info = new String[]{'recallActions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recordEditability_type_info = new String[]{'recordEditability','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] showApprovalHistory_type_info = new String[]{'showApprovalHistory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','allowRecall','allowedSubmitters','approvalPageFields','approvalStep','description','emailTemplate','enableMobileDeviceAccess','entryCriteria','finalApprovalActions','finalApprovalRecordLock','finalRejectionActions','finalRejectionRecordLock','initialSubmissionActions','label','nextAutomatedApprover','postTemplate','recallActions','recordEditability','showApprovalHistory'};
    }
    public with sharing class MilestoneType extends Metadata {
        public String type = 'MilestoneType';
        public String fullName;
        public String description;
        public String recurrenceType;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recurrenceType_type_info = new String[]{'recurrenceType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','recurrenceType'};
    }
    public with sharing class FileProperties {
        public String createdById;
        public String createdByName;
        public DateTime createdDate;
        public String fileName;
        public String fullName;
        public String id;
        public String lastModifiedById;
        public String lastModifiedByName;
        public DateTime lastModifiedDate;
        public String manageableState;
        public String namespacePrefix;
        public String type_x;
        public String[] createdById_type_info = new String[]{'createdById','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] createdByName_type_info = new String[]{'createdByName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] createdDate_type_info = new String[]{'createdDate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] fileName_type_info = new String[]{'fileName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] fullName_type_info = new String[]{'fullName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] lastModifiedById_type_info = new String[]{'lastModifiedById','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] lastModifiedByName_type_info = new String[]{'lastModifiedByName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] lastModifiedDate_type_info = new String[]{'lastModifiedDate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] manageableState_type_info = new String[]{'manageableState','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public String[] namespacePrefix_type_info = new String[]{'namespacePrefix','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        public String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'createdById','createdByName','createdDate','fileName','fullName','id','lastModifiedById','lastModifiedByName','lastModifiedDate','manageableState','namespacePrefix','type_x'};
    }
    public with sharing class UserMembershipSharingRule {
        public String description;
        public String name;
        public String userAccessLevel;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] userAccessLevel_type_info = new String[]{'userAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','name','userAccessLevel'};
    }
    public with sharing class QuickActionLayout {
        public String layoutSectionStyle;
        public MetadataService.QuickActionLayoutColumn[] quickActionLayoutColumns;
        private String[] layoutSectionStyle_type_info = new String[]{'layoutSectionStyle','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] quickActionLayoutColumns_type_info = new String[]{'quickActionLayoutColumns','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'layoutSectionStyle','quickActionLayoutColumns'};
    }
    public with sharing class Flow extends Metadata {
        public String type = 'Flow';
        public String fullName;
        public MetadataService.FlowActionCall[] actionCalls;
        public MetadataService.FlowApexPluginCall[] apexPluginCalls;
        public MetadataService.FlowAssignment[] assignments;
        public MetadataService.FlowChoice[] choices;
        public MetadataService.FlowConstant[] constants;
        public MetadataService.FlowDecision[] decisions;
        public String description;
        public MetadataService.FlowDynamicChoiceSet[] dynamicChoiceSets;
        public MetadataService.FlowFormula[] formulas;
        public String label;
        public MetadataService.FlowLoop[] loops;
        public MetadataService.FlowMetadataValue[] processMetadataValues;
        public String processType;
        public MetadataService.FlowRecordCreate[] recordCreates;
        public MetadataService.FlowRecordDelete[] recordDeletes;
        public MetadataService.FlowRecordLookup[] recordLookups;
        public MetadataService.FlowRecordUpdate[] recordUpdates;
        public MetadataService.FlowScreen[] screens;
        public String startElementReference;
        public MetadataService.FlowStep[] steps;
        public MetadataService.FlowSubflow[] subflows;
        public MetadataService.FlowTextTemplate[] textTemplates;
        public MetadataService.FlowVariable[] variables;
        public MetadataService.FlowWait[] waits;
        private String[] actionCalls_type_info = new String[]{'actionCalls','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apexPluginCalls_type_info = new String[]{'apexPluginCalls','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] assignments_type_info = new String[]{'assignments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] choices_type_info = new String[]{'choices','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] constants_type_info = new String[]{'constants','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] decisions_type_info = new String[]{'decisions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] dynamicChoiceSets_type_info = new String[]{'dynamicChoiceSets','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] formulas_type_info = new String[]{'formulas','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] loops_type_info = new String[]{'loops','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] processMetadataValues_type_info = new String[]{'processMetadataValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] processType_type_info = new String[]{'processType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recordCreates_type_info = new String[]{'recordCreates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] recordDeletes_type_info = new String[]{'recordDeletes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] recordLookups_type_info = new String[]{'recordLookups','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] recordUpdates_type_info = new String[]{'recordUpdates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] screens_type_info = new String[]{'screens','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] startElementReference_type_info = new String[]{'startElementReference','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] steps_type_info = new String[]{'steps','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] subflows_type_info = new String[]{'subflows','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] textTemplates_type_info = new String[]{'textTemplates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] variables_type_info = new String[]{'variables','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] waits_type_info = new String[]{'waits','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'actionCalls','apexPluginCalls','assignments','choices','constants','decisions','description','dynamicChoiceSets','formulas','label','loops','processMetadataValues','processType','recordCreates','recordDeletes','recordLookups','recordUpdates','screens','startElementReference','steps','subflows','textTemplates','variables','waits'};
    }
    public with sharing class AutoResponseRule extends Metadata {
        public String type = 'AutoResponseRule';
        public String fullName;
        public Boolean active;
        public MetadataService.RuleEntry[] ruleEntry;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] ruleEntry_type_info = new String[]{'ruleEntry','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','ruleEntry'};
    }
    public with sharing class PermissionSetObjectPermissions {
        public Boolean allowCreate;
        public Boolean allowDelete;
        public Boolean allowEdit;
        public Boolean allowRead;
        public Boolean modifyAllRecords;
        public String object_x;
        public Boolean viewAllRecords;
        private String[] allowCreate_type_info = new String[]{'allowCreate','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] allowDelete_type_info = new String[]{'allowDelete','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] allowEdit_type_info = new String[]{'allowEdit','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] allowRead_type_info = new String[]{'allowRead','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] modifyAllRecords_type_info = new String[]{'modifyAllRecords','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] viewAllRecords_type_info = new String[]{'viewAllRecords','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'allowCreate','allowDelete','allowEdit','allowRead','modifyAllRecords','object_x','viewAllRecords'};
    }
    public with sharing class ReportCrossFilter {
        public MetadataService.ReportFilterItem[] criteriaItems;
        public String operation;
        public String primaryTableColumn;
        public String relatedTable;
        public String relatedTableJoinColumn;
        private String[] criteriaItems_type_info = new String[]{'criteriaItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] operation_type_info = new String[]{'operation','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] primaryTableColumn_type_info = new String[]{'primaryTableColumn','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] relatedTable_type_info = new String[]{'relatedTable','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] relatedTableJoinColumn_type_info = new String[]{'relatedTableJoinColumn','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaItems','operation','primaryTableColumn','relatedTable','relatedTableJoinColumn'};
    }
    public with sharing class BusinessHoursSettings extends Metadata {
        public String type = 'BusinessHoursSettings';
        public String fullName;
        public MetadataService.BusinessHoursEntry[] businessHours;
        public MetadataService.Holiday[] holidays;
        private String[] businessHours_type_info = new String[]{'businessHours','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] holidays_type_info = new String[]{'holidays','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'businessHours','holidays'};
    }
    public with sharing class FlowWaitEventOutputParameter {
        public String assignToReference;
        public String name;
        private String[] assignToReference_type_info = new String[]{'assignToReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','name'};
    }
    public with sharing class Report extends Metadata {
        public String type = 'Report';
        public String fullName;
        public MetadataService.ReportAggregate[] aggregates;
        public MetadataService.Report[] block;
        public MetadataService.ReportBlockInfo blockInfo;
        public MetadataService.ReportBucketField[] buckets;
        public MetadataService.ReportChart chart;
        public MetadataService.ReportColorRange[] colorRanges;
        public MetadataService.ReportColumn[] columns;
        public MetadataService.ReportCrossFilter[] crossFilters;
        public String currency_x;
        public MetadataService.ReportDataCategoryFilter[] dataCategoryFilters;
        public String description;
        public String division;
        public MetadataService.ReportFilter filter;
        public String format;
        public MetadataService.ReportGrouping[] groupingsAcross;
        public MetadataService.ReportGrouping[] groupingsDown;
        public MetadataService.ReportHistoricalSelector historicalSelector;
        public String name;
        public MetadataService.ReportParam[] params;
        public String reportType;
        public String roleHierarchyFilter;
        public Integer rowLimit;
        public String scope;
        public Boolean showCurrentDate;
        public Boolean showDetails;
        public String sortColumn;
        public String sortOrder;
        public String territoryHierarchyFilter;
        public MetadataService.ReportTimeFrameFilter timeFrameFilter;
        public String userFilter;
        private String[] aggregates_type_info = new String[]{'aggregates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] block_type_info = new String[]{'block','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] blockInfo_type_info = new String[]{'blockInfo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] buckets_type_info = new String[]{'buckets','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] chart_type_info = new String[]{'chart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] colorRanges_type_info = new String[]{'colorRanges','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] columns_type_info = new String[]{'columns','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] crossFilters_type_info = new String[]{'crossFilters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] currency_x_type_info = new String[]{'currency','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] dataCategoryFilters_type_info = new String[]{'dataCategoryFilters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] division_type_info = new String[]{'division','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] filter_type_info = new String[]{'filter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] format_type_info = new String[]{'format','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] groupingsAcross_type_info = new String[]{'groupingsAcross','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] groupingsDown_type_info = new String[]{'groupingsDown','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] historicalSelector_type_info = new String[]{'historicalSelector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] params_type_info = new String[]{'params','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] reportType_type_info = new String[]{'reportType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] roleHierarchyFilter_type_info = new String[]{'roleHierarchyFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] rowLimit_type_info = new String[]{'rowLimit','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scope_type_info = new String[]{'scope','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showCurrentDate_type_info = new String[]{'showCurrentDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showDetails_type_info = new String[]{'showDetails','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortColumn_type_info = new String[]{'sortColumn','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortOrder_type_info = new String[]{'sortOrder','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] territoryHierarchyFilter_type_info = new String[]{'territoryHierarchyFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] timeFrameFilter_type_info = new String[]{'timeFrameFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] userFilter_type_info = new String[]{'userFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'aggregates','block','blockInfo','buckets','chart','colorRanges','columns','crossFilters','currency_x','dataCategoryFilters','description','division','filter','format','groupingsAcross','groupingsDown','historicalSelector','name','params','reportType','roleHierarchyFilter','rowLimit','scope','showCurrentDate','showDetails','sortColumn','sortOrder','territoryHierarchyFilter','timeFrameFilter','userFilter'};
    }
    public with sharing class ListView extends Metadata {
        public String type = 'ListView';
        public String fullName;
        public String booleanFilter;
        public String[] columns;
        public String division;
        public String filterScope;
        public MetadataService.ListViewFilter[] filters;
        public String label;
        public String language;
        public String queue;
        public MetadataService.SharedTo sharedTo;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] columns_type_info = new String[]{'columns','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] division_type_info = new String[]{'division','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] filterScope_type_info = new String[]{'filterScope','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] filters_type_info = new String[]{'filters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] language_type_info = new String[]{'language','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] queue_type_info = new String[]{'queue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sharedTo_type_info = new String[]{'sharedTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'booleanFilter','columns','division','filterScope','filters','label','language','queue','sharedTo'};
    }
    public with sharing class FlowRecordCreate {
        public String assignRecordIdToReference;
        public MetadataService.FlowConnector connector;
        public MetadataService.FlowConnector faultConnector;
        public MetadataService.FlowInputFieldAssignment[] inputAssignments;
        public String inputReference;
        public String object_x;
        private String[] assignRecordIdToReference_type_info = new String[]{'assignRecordIdToReference','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] faultConnector_type_info = new String[]{'faultConnector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inputAssignments_type_info = new String[]{'inputAssignments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] inputReference_type_info = new String[]{'inputReference','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignRecordIdToReference','connector','faultConnector','inputAssignments','inputReference','object_x'};
    }
    public with sharing class DashboardTableColumn {
        public String aggregateType;
        public Boolean calculatePercent;
        public String column;
        public Integer decimalPlaces;
        public Boolean showTotal;
        public String sortBy;
        private String[] aggregateType_type_info = new String[]{'aggregateType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] calculatePercent_type_info = new String[]{'calculatePercent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] column_type_info = new String[]{'column','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] decimalPlaces_type_info = new String[]{'decimalPlaces','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showTotal_type_info = new String[]{'showTotal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortBy_type_info = new String[]{'sortBy','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'aggregateType','calculatePercent','column','decimalPlaces','showTotal','sortBy'};
    }
    public with sharing class CaseSettings extends Metadata {
        public String type = 'CaseSettings';
        public String fullName;
        public String caseAssignNotificationTemplate;
        public String caseCloseNotificationTemplate;
        public String caseCommentNotificationTemplate;
        public String caseCreateNotificationTemplate;
        public MetadataService.FeedItemSettings[] caseFeedItemSettings;
        public Boolean closeCaseThroughStatusChange;
        public String defaultCaseOwner;
        public String defaultCaseOwnerType;
        public String defaultCaseUser;
        public MetadataService.EmailToCaseSettings emailToCase;
        public Boolean enableCaseFeed;
        public Boolean enableDraftEmails;
        public Boolean enableEarlyEscalationRuleTriggers;
        public Boolean enableNewEmailDefaultTemplate;
        public Boolean enableSuggestedArticlesApplication;
        public Boolean enableSuggestedArticlesCustomerPortal;
        public Boolean enableSuggestedArticlesPartnerPortal;
        public Boolean enableSuggestedSolutions;
        public Boolean keepRecordTypeOnAssignmentRule;
        public String newEmailDefaultTemplateClass;
        public Boolean notifyContactOnCaseComment;
        public Boolean notifyDefaultCaseOwner;
        public Boolean notifyOwnerOnCaseComment;
        public Boolean notifyOwnerOnCaseOwnerChange;
        public Boolean showFewerCloseActions;
        public Boolean useSystemEmailAddress;
        public MetadataService.WebToCaseSettings webToCase;
        private String[] caseAssignNotificationTemplate_type_info = new String[]{'caseAssignNotificationTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseCloseNotificationTemplate_type_info = new String[]{'caseCloseNotificationTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseCommentNotificationTemplate_type_info = new String[]{'caseCommentNotificationTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseCreateNotificationTemplate_type_info = new String[]{'caseCreateNotificationTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseFeedItemSettings_type_info = new String[]{'caseFeedItemSettings','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] closeCaseThroughStatusChange_type_info = new String[]{'closeCaseThroughStatusChange','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultCaseOwner_type_info = new String[]{'defaultCaseOwner','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultCaseOwnerType_type_info = new String[]{'defaultCaseOwnerType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultCaseUser_type_info = new String[]{'defaultCaseUser','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailToCase_type_info = new String[]{'emailToCase','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableCaseFeed_type_info = new String[]{'enableCaseFeed','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableDraftEmails_type_info = new String[]{'enableDraftEmails','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableEarlyEscalationRuleTriggers_type_info = new String[]{'enableEarlyEscalationRuleTriggers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableNewEmailDefaultTemplate_type_info = new String[]{'enableNewEmailDefaultTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSuggestedArticlesApplication_type_info = new String[]{'enableSuggestedArticlesApplication','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSuggestedArticlesCustomerPortal_type_info = new String[]{'enableSuggestedArticlesCustomerPortal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSuggestedArticlesPartnerPortal_type_info = new String[]{'enableSuggestedArticlesPartnerPortal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSuggestedSolutions_type_info = new String[]{'enableSuggestedSolutions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] keepRecordTypeOnAssignmentRule_type_info = new String[]{'keepRecordTypeOnAssignmentRule','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] newEmailDefaultTemplateClass_type_info = new String[]{'newEmailDefaultTemplateClass','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyContactOnCaseComment_type_info = new String[]{'notifyContactOnCaseComment','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyDefaultCaseOwner_type_info = new String[]{'notifyDefaultCaseOwner','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyOwnerOnCaseComment_type_info = new String[]{'notifyOwnerOnCaseComment','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] notifyOwnerOnCaseOwnerChange_type_info = new String[]{'notifyOwnerOnCaseOwnerChange','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showFewerCloseActions_type_info = new String[]{'showFewerCloseActions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] useSystemEmailAddress_type_info = new String[]{'useSystemEmailAddress','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] webToCase_type_info = new String[]{'webToCase','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'caseAssignNotificationTemplate','caseCloseNotificationTemplate','caseCommentNotificationTemplate','caseCreateNotificationTemplate','caseFeedItemSettings','closeCaseThroughStatusChange','defaultCaseOwner','defaultCaseOwnerType','defaultCaseUser','emailToCase','enableCaseFeed','enableDraftEmails','enableEarlyEscalationRuleTriggers','enableNewEmailDefaultTemplate','enableSuggestedArticlesApplication','enableSuggestedArticlesCustomerPortal','enableSuggestedArticlesPartnerPortal','enableSuggestedSolutions','keepRecordTypeOnAssignmentRule','newEmailDefaultTemplateClass','notifyContactOnCaseComment','notifyDefaultCaseOwner','notifyOwnerOnCaseComment','notifyOwnerOnCaseOwnerChange','showFewerCloseActions','useSystemEmailAddress','webToCase'};
    }
    public with sharing class NameSettings extends Metadata {
        public String type = 'NameSettings';
        public String fullName;
        public Boolean enableMiddleName;
        public Boolean enableNameSuffix;
        private String[] enableMiddleName_type_info = new String[]{'enableMiddleName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableNameSuffix_type_info = new String[]{'enableNameSuffix','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'enableMiddleName','enableNameSuffix'};
    }
    public with sharing class AsyncResult {
        public Boolean done;
        public String id;
        public String message;
        public String state;
        public String statusCode;
        private String[] done_type_info = new String[]{'done','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] message_type_info = new String[]{'message','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] state_type_info = new String[]{'state','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'done','id','message','state','statusCode'};
    }
    public with sharing class ArticleTypeChannelDisplay {
        public MetadataService.ArticleTypeTemplate[] articleTypeTemplates;
        private String[] articleTypeTemplates_type_info = new String[]{'articleTypeTemplates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'articleTypeTemplates'};
    }
    public with sharing class checkRetrieveStatus_element {
        public String asyncProcessId;
        private String[] asyncProcessId_type_info = new String[]{'asyncProcessId','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'asyncProcessId'};
    }
    public with sharing class ProfileLayoutAssignment {
        public String layout;
        public String recordType;
        private String[] layout_type_info = new String[]{'layout','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] recordType_type_info = new String[]{'recordType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'layout','recordType'};
    }
    public with sharing class FeedLayoutFilter {
        public String feedFilterType;
        public String feedItemType;
        private String[] feedFilterType_type_info = new String[]{'feedFilterType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] feedItemType_type_info = new String[]{'feedItemType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'feedFilterType','feedItemType'};
    }
    public with sharing class ReportHistoricalSelector {
        public String[] snapshot;
        private String[] snapshot_type_info = new String[]{'snapshot','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'snapshot'};
    }
    public with sharing class FlowTextTemplate {
        public String text;
        private String[] text_type_info = new String[]{'text','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'text'};
    }
    public with sharing class ReportFolder extends Folder {
        public String type = 'ReportFolder';
        public String fullName;
        public String accessType;
        public MetadataService.FolderShare[] folderShares;
        public String name;
        public String publicFolderAccess;
        public MetadataService.SharedTo sharedTo;
        private String[] accessType_type_info = new String[]{'accessType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] folderShares_type_info = new String[]{'folderShares','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] publicFolderAccess_type_info = new String[]{'publicFolderAccess','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sharedTo_type_info = new String[]{'sharedTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'accessType','folderShares','name','publicFolderAccess','sharedTo'};        
    }
    public with sharing class RelatedListItem {
        public String[] customButtons;
        public String[] excludeButtons;
        public String[] fields;
        public String relatedList;
        public String sortField;
        public String sortOrder;
        private String[] customButtons_type_info = new String[]{'customButtons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] excludeButtons_type_info = new String[]{'excludeButtons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] relatedList_type_info = new String[]{'relatedList','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sortField_type_info = new String[]{'sortField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortOrder_type_info = new String[]{'sortOrder','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'customButtons','excludeButtons','fields','relatedList','sortField','sortOrder'};
    }
    public with sharing class FlowNode {
        public String label;
        public Integer locationX;
        public Integer locationY;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] locationX_type_info = new String[]{'locationX','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] locationY_type_info = new String[]{'locationY','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','locationX','locationY'};
    }
    public with sharing class ProfileApexClassAccess {
        public String apexClass;
        public Boolean enabled;
        private String[] apexClass_type_info = new String[]{'apexClass','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apexClass','enabled'};
    }
    public with sharing class CustomDataTypeComponentTranslation {
        public String developerSuffix;
        public String label;
        private String[] developerSuffix_type_info = new String[]{'developerSuffix','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'developerSuffix','label'};
    }
    public with sharing class ReputationPointsRules {
        public MetadataService.ReputationPointsRule[] pointsRule;
        private String[] pointsRule_type_info = new String[]{'pointsRule','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'pointsRule'};
    }
    public with sharing class State {
        public Boolean active;
        public String integrationValue;
        public String isoCode;
        public String label;
        public Boolean standard;
        public Boolean visible;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] integrationValue_type_info = new String[]{'integrationValue','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isoCode_type_info = new String[]{'isoCode','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] standard_type_info = new String[]{'standard','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] visible_type_info = new String[]{'visible','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'active','integrationValue','isoCode','label','standard','visible'};
    }
    public with sharing class PushNotifications {
        public MetadataService.PushNotification[] pushNotification;
        private String[] pushNotification_type_info = new String[]{'pushNotification','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'pushNotification'};
    }
    public with sharing class ConnectedAppCanvasConfig {
        public String accessMethod;
        public String canvasUrl;
        public String lifecycleClass;
        public String[] locations;
        public String[] options;
        public String samlInitiationMethod;
        private String[] accessMethod_type_info = new String[]{'accessMethod','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] canvasUrl_type_info = new String[]{'canvasUrl','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lifecycleClass_type_info = new String[]{'lifecycleClass','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] locations_type_info = new String[]{'locations','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] options_type_info = new String[]{'options','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] samlInitiationMethod_type_info = new String[]{'samlInitiationMethod','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accessMethod','canvasUrl','lifecycleClass','locations','options','samlInitiationMethod'};
    }
    public with sharing class ReportTypeSectionTranslation {
        public MetadataService.ReportTypeColumnTranslation[] columns;
        public String label;
        public String name;
        private String[] columns_type_info = new String[]{'columns','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'columns','label','name'};
    }
    public with sharing class FlowWaitEvent {
        public String conditionLogic;
        public MetadataService.FlowCondition[] conditions;
        public MetadataService.FlowConnector connector;
        public String eventType;
        public MetadataService.FlowWaitEventInputParameter[] inputParameters;
        public String label;
        public MetadataService.FlowWaitEventOutputParameter[] outputParameters;
        private String[] conditionLogic_type_info = new String[]{'conditionLogic','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] conditions_type_info = new String[]{'conditions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] eventType_type_info = new String[]{'eventType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] inputParameters_type_info = new String[]{'inputParameters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] outputParameters_type_info = new String[]{'outputParameters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'conditionLogic','conditions','connector','eventType','inputParameters','label','outputParameters'};
    }
    public with sharing class IpRange {
        public String end_x;
        public String start;
        private String[] end_x_type_info = new String[]{'end','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] start_type_info = new String[]{'start','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'end_x','start'};
    }
    public with sharing class FlowApexPluginCallOutputParameter {
        public String assignToReference;
        public String name;
        private String[] assignToReference_type_info = new String[]{'assignToReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','name'};
    }
    public with sharing class ReportBucketField {
        public String bucketType;
        public String developerName;
        public String masterLabel;
        public String nullTreatment;
        public String otherBucketLabel;
        public String sourceColumnName;
        public Boolean useOther;
        public MetadataService.ReportBucketFieldValue[] values;
        private String[] bucketType_type_info = new String[]{'bucketType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] developerName_type_info = new String[]{'developerName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] nullTreatment_type_info = new String[]{'nullTreatment','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] otherBucketLabel_type_info = new String[]{'otherBucketLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sourceColumnName_type_info = new String[]{'sourceColumnName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] useOther_type_info = new String[]{'useOther','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] values_type_info = new String[]{'values','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'bucketType','developerName','masterLabel','nullTreatment','otherBucketLabel','sourceColumnName','useOther','values'};
    }
    public with sharing class CaseCriteriaBasedSharingRule {
        public String booleanFilter;
        public String caseAccessLevel;
        public String description;
        public String name;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseAccessLevel_type_info = new String[]{'caseAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanFilter','caseAccessLevel','description','name'};
    }
    public with sharing class Portal extends Metadata {
        public String type = 'Portal';
        public String fullName;
        public Boolean active;
        public String admin;
        public String defaultLanguage;
        public String description;
        public String emailSenderAddress;
        public String emailSenderName;
        public Boolean enableSelfCloseCase;
        public String footerDocument;
        public String forgotPassTemplate;
        public String headerDocument;
        public Boolean isSelfRegistrationActivated;
        public String loginHeaderDocument;
        public String logoDocument;
        public String logoutUrl;
        public String newCommentTemplate;
        public String newPassTemplate;
        public String newUserTemplate;
        public String ownerNotifyTemplate;
        public String selfRegNewUserUrl;
        public String selfRegUserDefaultProfile;
        public String selfRegUserDefaultRole;
        public String selfRegUserTemplate;
        public Boolean showActionConfirmation;
        public String stylesheetDocument;
        public String type_x;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] admin_type_info = new String[]{'admin','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultLanguage_type_info = new String[]{'defaultLanguage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailSenderAddress_type_info = new String[]{'emailSenderAddress','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] emailSenderName_type_info = new String[]{'emailSenderName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enableSelfCloseCase_type_info = new String[]{'enableSelfCloseCase','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] footerDocument_type_info = new String[]{'footerDocument','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] forgotPassTemplate_type_info = new String[]{'forgotPassTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] headerDocument_type_info = new String[]{'headerDocument','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isSelfRegistrationActivated_type_info = new String[]{'isSelfRegistrationActivated','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] loginHeaderDocument_type_info = new String[]{'loginHeaderDocument','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] logoDocument_type_info = new String[]{'logoDocument','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] logoutUrl_type_info = new String[]{'logoutUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] newCommentTemplate_type_info = new String[]{'newCommentTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] newPassTemplate_type_info = new String[]{'newPassTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] newUserTemplate_type_info = new String[]{'newUserTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] ownerNotifyTemplate_type_info = new String[]{'ownerNotifyTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] selfRegNewUserUrl_type_info = new String[]{'selfRegNewUserUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] selfRegUserDefaultProfile_type_info = new String[]{'selfRegUserDefaultProfile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] selfRegUserDefaultRole_type_info = new String[]{'selfRegUserDefaultRole','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] selfRegUserTemplate_type_info = new String[]{'selfRegUserTemplate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showActionConfirmation_type_info = new String[]{'showActionConfirmation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] stylesheetDocument_type_info = new String[]{'stylesheetDocument','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','admin','defaultLanguage','description','emailSenderAddress','emailSenderName','enableSelfCloseCase','footerDocument','forgotPassTemplate','headerDocument','isSelfRegistrationActivated','loginHeaderDocument','logoDocument','logoutUrl','newCommentTemplate','newPassTemplate','newUserTemplate','ownerNotifyTemplate','selfRegNewUserUrl','selfRegUserDefaultProfile','selfRegUserDefaultRole','selfRegUserTemplate','showActionConfirmation','stylesheetDocument','type_x'};
    }
    public with sharing class DomainWhitelist {
        public String[] domain;
        private String[] domain_type_info = new String[]{'domain','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'domain'};
    }
    public with sharing class RunTestFailure {
        public String id;
        public String message;
        public String methodName;
        public String name;
        public String namespace;
        public String packageName;
        public String stackTrace;
        public Double time_x;
        public String type_x;
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] message_type_info = new String[]{'message','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] methodName_type_info = new String[]{'methodName','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] namespace_type_info = new String[]{'namespace','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] packageName_type_info = new String[]{'packageName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] stackTrace_type_info = new String[]{'stackTrace','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] time_x_type_info = new String[]{'time','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'id','message','methodName','name','namespace','packageName','stackTrace','time_x','type_x'};
    }
    public with sharing class Territory {
        public String accountAccessLevel;
        public String parentTerritory;
        private String[] accountAccessLevel_type_info = new String[]{'accountAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] parentTerritory_type_info = new String[]{'parentTerritory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accountAccessLevel','parentTerritory'};
    }
    public with sharing class SharedTo {
        public String allCustomerPortalUsers;
        public String allInternalUsers;
        public String allPartnerUsers;
        public String[] group_x;
        public String[] groups;
        public String[] managerSubordinates;
        public String[] managers;
        public String[] portalRole;
        public String[] portalRoleAndSubordinates;
        public String[] queue;
        public String[] role;
        public String[] roleAndSubordinates;
        public String[] roleAndSubordinatesInternal;
        public String[] roles;
        public String[] rolesAndSubordinates;
        public String[] territories;
        public String[] territoriesAndSubordinates;
        public String[] territory;
        public String[] territoryAndSubordinates;
        private String[] allCustomerPortalUsers_type_info = new String[]{'allCustomerPortalUsers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allInternalUsers_type_info = new String[]{'allInternalUsers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allPartnerUsers_type_info = new String[]{'allPartnerUsers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] group_x_type_info = new String[]{'group','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] groups_type_info = new String[]{'groups','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] managerSubordinates_type_info = new String[]{'managerSubordinates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] managers_type_info = new String[]{'managers','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] portalRole_type_info = new String[]{'portalRole','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] portalRoleAndSubordinates_type_info = new String[]{'portalRoleAndSubordinates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] queue_type_info = new String[]{'queue','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] role_type_info = new String[]{'role','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] roleAndSubordinates_type_info = new String[]{'roleAndSubordinates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] roleAndSubordinatesInternal_type_info = new String[]{'roleAndSubordinatesInternal','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] roles_type_info = new String[]{'roles','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] rolesAndSubordinates_type_info = new String[]{'rolesAndSubordinates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] territories_type_info = new String[]{'territories','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] territoriesAndSubordinates_type_info = new String[]{'territoriesAndSubordinates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] territory_type_info = new String[]{'territory','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] territoryAndSubordinates_type_info = new String[]{'territoryAndSubordinates','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'allCustomerPortalUsers','allInternalUsers','allPartnerUsers','group_x','groups','managerSubordinates','managers','portalRole','portalRoleAndSubordinates','queue','role','roleAndSubordinates','roleAndSubordinatesInternal','roles','rolesAndSubordinates','territories','territoriesAndSubordinates','territory','territoryAndSubordinates'};
    }
    public with sharing class DeployDetails {
        public MetadataService.DeployMessage[] componentFailures;
        public MetadataService.DeployMessage[] componentSuccesses;
        public MetadataService.RetrieveResult retrieveResult;
        public MetadataService.RunTestsResult runTestResult;
        private String[] componentFailures_type_info = new String[]{'componentFailures','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] componentSuccesses_type_info = new String[]{'componentSuccesses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] retrieveResult_type_info = new String[]{'retrieveResult','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] runTestResult_type_info = new String[]{'runTestResult','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'componentFailures','componentSuccesses','retrieveResult','runTestResult'};
    }
    public with sharing class FlowRecordFilter {
        public String field;
        public String operator;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','operator','value'};
    }
    public with sharing class Group_x extends Metadata {
        public String type = 'Group_x';
        public String fullName;
        public Boolean doesIncludeBosses;
        public String name;
        private String[] doesIncludeBosses_type_info = new String[]{'doesIncludeBosses','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'doesIncludeBosses','name'};
    }
    public with sharing class SubtabComponents {
        public MetadataService.Container[] containers;
        private String[] containers_type_info = new String[]{'containers','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'containers'};
    }
    public with sharing class FlowScreen {
        public Boolean allowBack;
        public Boolean allowFinish;
        public MetadataService.FlowConnector connector;
        public MetadataService.FlowScreenField[] fields;
        public String helpText;
        private String[] allowBack_type_info = new String[]{'allowBack','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowFinish_type_info = new String[]{'allowFinish','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] helpText_type_info = new String[]{'helpText','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'allowBack','allowFinish','connector','fields','helpText'};
    }
    public with sharing class WorkflowAlert extends WorkflowAction {
        public String type = 'WorkflowAlert';
        public String fullName;
        public String[] ccEmails;
        public String description;
        public Boolean protected_x;
        public MetadataService.WorkflowEmailRecipient[] recipients;
        public String senderAddress;
        public String senderType;
        public String template;
        private String[] ccEmails_type_info = new String[]{'ccEmails','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] recipients_type_info = new String[]{'recipients','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] senderAddress_type_info = new String[]{'senderAddress','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] senderType_type_info = new String[]{'senderType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] template_type_info = new String[]{'template','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'ccEmails','description','protected_x','recipients','senderAddress','senderType','template'};
    }
    public with sharing class CustomPermissionDependencyRequired {
        public String customPermission;
        public Boolean dependency;
        private String[] customPermission_type_info = new String[]{'customPermission','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] dependency_type_info = new String[]{'dependency','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'customPermission','dependency'};
    }
    public with sharing class ReputationBranding {
        public String smallImage;
        private String[] smallImage_type_info = new String[]{'smallImage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'smallImage'};
    }
    public with sharing class ForecastRangeSettings {
        public Integer beginning;
        public Integer displaying;
        public String periodType;
        private String[] beginning_type_info = new String[]{'beginning','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] displaying_type_info = new String[]{'displaying','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] periodType_type_info = new String[]{'periodType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'beginning','displaying','periodType'};
    }
    public with sharing class SFDCMobileSettings {
        public Boolean enableMobileLite;
        public Boolean enableUserToDeviceLinking;
        private String[] enableMobileLite_type_info = new String[]{'enableMobileLite','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableUserToDeviceLinking_type_info = new String[]{'enableUserToDeviceLinking','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enableMobileLite','enableUserToDeviceLinking'};
    }
    public with sharing class LayoutSectionTranslation {
        public String label;
        public String section;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] section_type_info = new String[]{'section','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','section'};
    }
    public with sharing class EntitlementProcessMilestoneItem {
        public String businessHours;
        public String criteriaBooleanFilter;
        public MetadataService.FilterItem[] milestoneCriteriaFilterItems;
        public String milestoneCriteriaFormula;
        public String milestoneName;
        public String minutesCustomClass;
        public Integer minutesToComplete;
        public MetadataService.WorkflowActionReference[] successActions;
        public MetadataService.EntitlementProcessMilestoneTimeTrigger[] timeTriggers;
        public Boolean useCriteriaStartTime;
        private String[] businessHours_type_info = new String[]{'businessHours','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] criteriaBooleanFilter_type_info = new String[]{'criteriaBooleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] milestoneCriteriaFilterItems_type_info = new String[]{'milestoneCriteriaFilterItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] milestoneCriteriaFormula_type_info = new String[]{'milestoneCriteriaFormula','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] milestoneName_type_info = new String[]{'milestoneName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] minutesCustomClass_type_info = new String[]{'minutesCustomClass','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] minutesToComplete_type_info = new String[]{'minutesToComplete','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] successActions_type_info = new String[]{'successActions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] timeTriggers_type_info = new String[]{'timeTriggers','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] useCriteriaStartTime_type_info = new String[]{'useCriteriaStartTime','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'businessHours','criteriaBooleanFilter','milestoneCriteriaFilterItems','milestoneCriteriaFormula','milestoneName','minutesCustomClass','minutesToComplete','successActions','timeTriggers','useCriteriaStartTime'};
    }
    public with sharing class DataCategoryGroup extends Metadata {
        public String type = 'DataCategoryGroup';
        public String fullName;
        public Boolean active;
        public MetadataService.DataCategory dataCategory;
        public String description;
        public String label;
        public MetadataService.ObjectUsage objectUsage;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] dataCategory_type_info = new String[]{'dataCategory','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] objectUsage_type_info = new String[]{'objectUsage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','dataCategory','description','label','objectUsage'};
    }
    public with sharing class listMetadata_element {
        public MetadataService.ListMetadataQuery[] queries;
        public Double asOfVersion;
        private String[] queries_type_info = new String[]{'queries','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] asOfVersion_type_info = new String[]{'asOfVersion','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'queries','asOfVersion'};
    }
    public with sharing class ValidationRule extends Metadata {
        public String type = 'ValidationRule';
        public String fullName;
        public Boolean active;
        public String description;
        public String errorConditionFormula;
        public String errorDisplayField;
        public String errorMessage;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] errorConditionFormula_type_info = new String[]{'errorConditionFormula','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] errorDisplayField_type_info = new String[]{'errorDisplayField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','description','errorConditionFormula','errorDisplayField','errorMessage'};
    }
    public with sharing class AuraDefinitionBundle extends Metadata {
        public String type = 'AuraDefinitionBundle';
        public String fullName;
        public String controllerContent;
        public String documentationContent;
        public String helperContent;
        public String markup;
        public String modelContent;
        public String rendererContent;
        public String styleContent;
        public String testsuiteContent;
        public String type_x;
        private String[] controllerContent_type_info = new String[]{'controllerContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] documentationContent_type_info = new String[]{'documentationContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] helperContent_type_info = new String[]{'helperContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] markup_type_info = new String[]{'markup','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] modelContent_type_info = new String[]{'modelContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] rendererContent_type_info = new String[]{'rendererContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] styleContent_type_info = new String[]{'styleContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] testsuiteContent_type_info = new String[]{'testsuiteContent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'controllerContent','documentationContent','helperContent','markup','modelContent','rendererContent','styleContent','testsuiteContent','type_x'};
    }
    public with sharing class FlowMetadataValue {
        public String name;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class VisualizationResource {
        public String description;
        public String file;
        public Integer rank;
        public String type_x;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] file_type_info = new String[]{'file','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] rank_type_info = new String[]{'rank','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','file','rank','type_x'};
    }
    public with sharing class ValidationRuleTranslation {
        public String errorMessage;
        public String name;
        private String[] errorMessage_type_info = new String[]{'errorMessage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'errorMessage','name'};
    }
    public virtual class Metadata {
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fullName'};
    }
    public with sharing class ReportBucketFieldValue {
        public MetadataService.ReportBucketFieldSourceValue[] sourceValues;
        public String value;
        private String[] sourceValues_type_info = new String[]{'sourceValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'sourceValues','value'};
    }
    public with sharing class FeedItemSettings {
        public Integer characterLimit;
        public Boolean collapseThread;
        public String displayFormat;
        public String feedItemType;
        private String[] characterLimit_type_info = new String[]{'characterLimit','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] collapseThread_type_info = new String[]{'collapseThread','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayFormat_type_info = new String[]{'displayFormat','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] feedItemType_type_info = new String[]{'feedItemType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'characterLimit','collapseThread','displayFormat','feedItemType'};
    }
    public with sharing class FlowSubflow {
        public MetadataService.FlowConnector connector;
        public String flowName;
        public MetadataService.FlowSubflowInputAssignment[] inputAssignments;
        public MetadataService.FlowSubflowOutputAssignment[] outputAssignments;
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] flowName_type_info = new String[]{'flowName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] inputAssignments_type_info = new String[]{'inputAssignments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] outputAssignments_type_info = new String[]{'outputAssignments','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'connector','flowName','inputAssignments','outputAssignments'};
    }
    public with sharing class TouchMobileSettings {
        public Boolean enableTouchAppIPad;
        public Boolean enableTouchAppIPhone;
        public Boolean enableTouchBrowserIPad;
        public Boolean enableTouchIosPhone;
        public Boolean enableVisualforceInTouch;
        private String[] enableTouchAppIPad_type_info = new String[]{'enableTouchAppIPad','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableTouchAppIPhone_type_info = new String[]{'enableTouchAppIPhone','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableTouchBrowserIPad_type_info = new String[]{'enableTouchBrowserIPad','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableTouchIosPhone_type_info = new String[]{'enableTouchIosPhone','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableVisualforceInTouch_type_info = new String[]{'enableVisualforceInTouch','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enableTouchAppIPad','enableTouchAppIPhone','enableTouchBrowserIPad','enableTouchIosPhone','enableVisualforceInTouch'};
    }
    public with sharing class FlowScreenField {
        public String[] choiceReferences;
        public String dataType;
        public String defaultSelectedChoiceReference;
        public MetadataService.FlowElementReferenceOrValue defaultValue;
        public String fieldText;
        public String fieldType;
        public String helpText;
        public Boolean isRequired;
        public Integer scale;
        public MetadataService.FlowInputValidationRule validationRule;
        private String[] choiceReferences_type_info = new String[]{'choiceReferences','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] dataType_type_info = new String[]{'dataType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultSelectedChoiceReference_type_info = new String[]{'defaultSelectedChoiceReference','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultValue_type_info = new String[]{'defaultValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fieldText_type_info = new String[]{'fieldText','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fieldType_type_info = new String[]{'fieldType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] helpText_type_info = new String[]{'helpText','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isRequired_type_info = new String[]{'isRequired','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scale_type_info = new String[]{'scale','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] validationRule_type_info = new String[]{'validationRule','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'choiceReferences','dataType','defaultSelectedChoiceReference','defaultValue','fieldText','fieldType','helpText','isRequired','scale','validationRule'};
    }
    public with sharing class Dashboard extends Metadata {
        public String type = 'Dashboard';
        public String fullName;
        public String backgroundEndColor;
        public String backgroundFadeDirection;
        public String backgroundStartColor;
        public MetadataService.DashboardFilter[] dashboardFilters;
        public String dashboardResultRefreshedDate;
        public String dashboardResultRunningUser;
        public String dashboardType;
        public String description;
        public MetadataService.DashboardComponentSection leftSection;
        public MetadataService.DashboardComponentSection middleSection;
        public MetadataService.DashboardComponentSection rightSection;
        public String runningUser;
        public String textColor;
        public String title;
        public String titleColor;
        public Integer titleSize;
        private String[] backgroundEndColor_type_info = new String[]{'backgroundEndColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] backgroundFadeDirection_type_info = new String[]{'backgroundFadeDirection','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] backgroundStartColor_type_info = new String[]{'backgroundStartColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] dashboardFilters_type_info = new String[]{'dashboardFilters','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] dashboardResultRefreshedDate_type_info = new String[]{'dashboardResultRefreshedDate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] dashboardResultRunningUser_type_info = new String[]{'dashboardResultRunningUser','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] dashboardType_type_info = new String[]{'dashboardType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] leftSection_type_info = new String[]{'leftSection','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] middleSection_type_info = new String[]{'middleSection','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] rightSection_type_info = new String[]{'rightSection','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] runningUser_type_info = new String[]{'runningUser','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] textColor_type_info = new String[]{'textColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] title_type_info = new String[]{'title','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] titleColor_type_info = new String[]{'titleColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] titleSize_type_info = new String[]{'titleSize','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'backgroundEndColor','backgroundFadeDirection','backgroundStartColor','dashboardFilters','dashboardResultRefreshedDate','dashboardResultRunningUser','dashboardType','description','leftSection','middleSection','rightSection','runningUser','textColor','title','titleColor','titleSize'};
    }
    public with sharing class ReportDataCategoryFilter {
        public String dataCategory;
        public String dataCategoryGroup;
        public String operator;
        private String[] dataCategory_type_info = new String[]{'dataCategory','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] dataCategoryGroup_type_info = new String[]{'dataCategoryGroup','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dataCategory','dataCategoryGroup','operator'};
    }
    public with sharing class MarketingActionSettings extends Metadata {
        public String type = 'MarketingActionSettings';
        public String fullName;
        public Boolean enableMarketingAction;
        private String[] enableMarketingAction_type_info = new String[]{'enableMarketingAction','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'enableMarketingAction'};
    }
    public with sharing class FlowAssignment {
        public MetadataService.FlowAssignmentItem[] assignmentItems;
        public MetadataService.FlowConnector connector;
        private String[] assignmentItems_type_info = new String[]{'assignmentItems','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] connector_type_info = new String[]{'connector','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignmentItems','connector'};
    }
    public with sharing class IdeaReputationLevel {
        public String name;
        public Integer value;
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public with sharing class NetworkTabSet {
        public String[] customTab;
        public String defaultTab;
        public String[] standardTab;
        private String[] customTab_type_info = new String[]{'customTab','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] defaultTab_type_info = new String[]{'defaultTab','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] standardTab_type_info = new String[]{'standardTab','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'customTab','defaultTab','standardTab'};
    }
    public with sharing class CustomApplicationComponents {
        public String alignment;
        public String[] customApplicationComponent;
        private String[] alignment_type_info = new String[]{'alignment','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] customApplicationComponent_type_info = new String[]{'customApplicationComponent','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'alignment','customApplicationComponent'};
    }
    public with sharing class SynonymGroup {
        public String[] languages;
        public String[] terms;
        private String[] languages_type_info = new String[]{'languages','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] terms_type_info = new String[]{'terms','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'languages','terms'};
    }
    public with sharing class VisualizationType {
        public String description;
        public String developerName;
        public String icon;
        public String masterLabel;
        public String scriptBootstrapMethod;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] developerName_type_info = new String[]{'developerName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] icon_type_info = new String[]{'icon','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] scriptBootstrapMethod_type_info = new String[]{'scriptBootstrapMethod','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','developerName','icon','masterLabel','scriptBootstrapMethod'};
    }
    public with sharing class DashboardFolder extends Folder {
        public String type = 'DashboardFolder';
        public String fullName;
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName'};
    }
    public with sharing class PermissionSetApexPageAccess {
        public String apexPage;
        public Boolean enabled;
        private String[] apexPage_type_info = new String[]{'apexPage','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enabled_type_info = new String[]{'enabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apexPage','enabled'};
    }
    public with sharing class CustomObject extends Metadata {
        public String type = 'CustomObject';
        public String fullName;
        public MetadataService.ActionOverride[] actionOverrides;
        public MetadataService.ArticleTypeChannelDisplay articleTypeChannelDisplay;
        public MetadataService.BusinessProcess[] businessProcesses;
        public String compactLayoutAssignment;
        public MetadataService.CompactLayout[] compactLayouts;
        public String customHelp;
        public String customHelpPage;
        public String customSettingsType;
        public String customSettingsVisibility;
        public String deploymentStatus;
        public Boolean deprecated;
        public String description;
        public Boolean enableActivities;
        public Boolean enableBulkApi;
        public Boolean enableDivisions;
        public Boolean enableEnhancedLookup;
        public Boolean enableFeeds;
        public Boolean enableHistory;
        public Boolean enableReports;
        public Boolean enableSharing;
        public Boolean enableStreamingApi;
        public String externalDataSource;
        public String externalName;
        public String externalRepository;
        public String externalSharingModel;
        public MetadataService.FieldSet[] fieldSets;
        public MetadataService.CustomField[] fields;
        public String gender;
        public MetadataService.HistoryRetentionPolicy historyRetentionPolicy;
        public Boolean household;
        public String label;
        public MetadataService.ListView[] listViews;
        public MetadataService.CustomField nameField;
        public String pluralLabel;
        public Boolean recordTypeTrackFeedHistory;
        public Boolean recordTypeTrackHistory;
        public MetadataService.RecordType[] recordTypes;
        public MetadataService.SearchLayouts searchLayouts;
        public String sharingModel;
        public MetadataService.SharingReason[] sharingReasons;
        public MetadataService.SharingRecalculation[] sharingRecalculations;
        public String startsWith;
        public MetadataService.ValidationRule[] validationRules;
        public MetadataService.WebLink[] webLinks;
        private String[] actionOverrides_type_info = new String[]{'actionOverrides','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] articleTypeChannelDisplay_type_info = new String[]{'articleTypeChannelDisplay','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] businessProcesses_type_info = new String[]{'businessProcesses','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] compactLayoutAssignment_type_info = new String[]{'compactLayoutAssignment','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] compactLayouts_type_info = new String[]{'compactLayouts','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] customHelp_type_info = new String[]{'customHelp','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customHelpPage_type_info = new String[]{'customHelpPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customSettingsType_type_info = new String[]{'customSettingsType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customSettingsVisibility_type_info = new String[]{'customSettingsVisibility','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] deploymentStatus_type_info = new String[]{'deploymentStatus','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] deprecated_type_info = new String[]{'deprecated','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableActivities_type_info = new String[]{'enableActivities','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableBulkApi_type_info = new String[]{'enableBulkApi','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableDivisions_type_info = new String[]{'enableDivisions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableEnhancedLookup_type_info = new String[]{'enableEnhancedLookup','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableFeeds_type_info = new String[]{'enableFeeds','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableHistory_type_info = new String[]{'enableHistory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableReports_type_info = new String[]{'enableReports','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableSharing_type_info = new String[]{'enableSharing','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableStreamingApi_type_info = new String[]{'enableStreamingApi','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalDataSource_type_info = new String[]{'externalDataSource','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalName_type_info = new String[]{'externalName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalRepository_type_info = new String[]{'externalRepository','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalSharingModel_type_info = new String[]{'externalSharingModel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fieldSets_type_info = new String[]{'fieldSets','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] gender_type_info = new String[]{'gender','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] historyRetentionPolicy_type_info = new String[]{'historyRetentionPolicy','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] household_type_info = new String[]{'household','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] listViews_type_info = new String[]{'listViews','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] nameField_type_info = new String[]{'nameField','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] pluralLabel_type_info = new String[]{'pluralLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recordTypeTrackFeedHistory_type_info = new String[]{'recordTypeTrackFeedHistory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recordTypeTrackHistory_type_info = new String[]{'recordTypeTrackHistory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] recordTypes_type_info = new String[]{'recordTypes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] searchLayouts_type_info = new String[]{'searchLayouts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sharingModel_type_info = new String[]{'sharingModel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sharingReasons_type_info = new String[]{'sharingReasons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] sharingRecalculations_type_info = new String[]{'sharingRecalculations','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] startsWith_type_info = new String[]{'startsWith','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] validationRules_type_info = new String[]{'validationRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] webLinks_type_info = new String[]{'webLinks','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'actionOverrides','articleTypeChannelDisplay','businessProcesses','compactLayoutAssignment','compactLayouts','customHelp','customHelpPage','customSettingsType','customSettingsVisibility','deploymentStatus','deprecated','description','enableActivities','enableBulkApi','enableDivisions','enableEnhancedLookup','enableFeeds','enableHistory','enableReports','enableSharing','enableStreamingApi','externalDataSource','externalName','externalRepository','externalSharingModel','fieldSets','fields','gender','historyRetentionPolicy','household','label','listViews','nameField','pluralLabel','recordTypeTrackFeedHistory','recordTypeTrackHistory','recordTypes','searchLayouts','sharingModel','sharingReasons','sharingRecalculations','startsWith','validationRules','webLinks'};
    }
    public with sharing class CustomMetadataValue {
        public String field;
        public String value;
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','value'};
    }
    public with sharing class Translations extends Metadata {
        public String type = 'Translations';
        public String fullName;
        public MetadataService.CustomApplicationTranslation[] customApplications;
        public MetadataService.CustomDataTypeTranslation[] customDataTypeTranslations;
        public MetadataService.CustomLabelTranslation[] customLabels;
        public MetadataService.CustomPageWebLinkTranslation[] customPageWebLinks;
        public MetadataService.CustomTabTranslation[] customTabs;
        public MetadataService.GlobalQuickActionTranslation[] quickActions;
        public MetadataService.ReportTypeTranslation[] reportTypes;
        public MetadataService.ScontrolTranslation[] scontrols;
        private String[] customApplications_type_info = new String[]{'customApplications','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] customDataTypeTranslations_type_info = new String[]{'customDataTypeTranslations','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] customLabels_type_info = new String[]{'customLabels','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] customPageWebLinks_type_info = new String[]{'customPageWebLinks','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] customTabs_type_info = new String[]{'customTabs','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] quickActions_type_info = new String[]{'quickActions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] reportTypes_type_info = new String[]{'reportTypes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] scontrols_type_info = new String[]{'scontrols','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'customApplications','customDataTypeTranslations','customLabels','customPageWebLinks','customTabs','quickActions','reportTypes','scontrols'};
    }
    public with sharing class ReportTypeTranslation {
        public String description;
        public String label;
        public String name;
        public MetadataService.ReportTypeSectionTranslation[] sections;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sections_type_info = new String[]{'sections','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','label','name','sections'};
    }
    public with sharing class FlowAssignmentItem {
        public String assignToReference;
        public String operator;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] assignToReference_type_info = new String[]{'assignToReference','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','operator','value'};
    }
    public with sharing class CustomLabels extends Metadata {
        public String type = 'CustomLabels';
        public String fullName;
        public MetadataService.CustomLabel[] labels;
        private String[] labels_type_info = new String[]{'labels','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'labels'};
    }
    public with sharing class PackageTypeMembers {
        public String[] members;
        public String name;
        private String[] members_type_info = new String[]{'members','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'members','name'};
    }
    public with sharing class renameMetadataResponse_element {
        public MetadataService.SaveResult result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class HistoryRetentionPolicy {
        public Integer archiveAfterMonths;
        public Integer archiveRetentionYears;
        public String description;
        private String[] archiveAfterMonths_type_info = new String[]{'archiveAfterMonths','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] archiveRetentionYears_type_info = new String[]{'archiveRetentionYears','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'archiveAfterMonths','archiveRetentionYears','description'};
    }
    public with sharing class cancelDeploy_element {
        public String String_x;
        private String[] String_x_type_info = new String[]{'String','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'String_x'};
    }
    public with sharing class WorkflowSend extends WorkflowAction {
        public String type = 'WorkflowSend';
        public String fullName;
        public String action;
        public String description;
        public String label;
        public String language;
        public Boolean protected_x;
        private String[] action_type_info = new String[]{'action','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] language_type_info = new String[]{'language','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] protected_x_type_info = new String[]{'protected','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'action','description','label','language','protected_x'};
    }
    public with sharing class EntitlementProcessMilestoneTimeTrigger {
        public MetadataService.WorkflowActionReference[] actions;
        public Integer timeLength;
        public String workflowTimeTriggerUnit;
        private String[] actions_type_info = new String[]{'actions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] timeLength_type_info = new String[]{'timeLength','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] workflowTimeTriggerUnit_type_info = new String[]{'workflowTimeTriggerUnit','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'actions','timeLength','workflowTimeTriggerUnit'};
    }
    public with sharing class ArticleTypeTemplate {
        public String channel;
        public String page_x;
        public String template;
        private String[] channel_type_info = new String[]{'channel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] template_type_info = new String[]{'template','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'channel','page_x','template'};
    }
    public with sharing class AnalyticSnapshotMapping {
        public String aggregateType;
        public String sourceField;
        public String sourceType;
        public String targetField;
        private String[] aggregateType_type_info = new String[]{'aggregateType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sourceField_type_info = new String[]{'sourceField','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sourceType_type_info = new String[]{'sourceType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] targetField_type_info = new String[]{'targetField','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'aggregateType','sourceField','sourceType','targetField'};
    }
    public with sharing class PermissionSetFieldPermissions {
        public Boolean editable;
        public String field;
        public Boolean readable;
        private String[] editable_type_info = new String[]{'editable','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] readable_type_info = new String[]{'readable','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'editable','field','readable'};
    }
    public with sharing class ReportGrouping {
        public String aggregateType;
        public String dateGranularity;
        public String field;
        public String sortByName;
        public String sortOrder;
        public String sortType;
        private String[] aggregateType_type_info = new String[]{'aggregateType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] dateGranularity_type_info = new String[]{'dateGranularity','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sortByName_type_info = new String[]{'sortByName','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortOrder_type_info = new String[]{'sortOrder','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sortType_type_info = new String[]{'sortType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'aggregateType','dateGranularity','field','sortByName','sortOrder','sortType'};
    }
    public with sharing class SkillProfileAssignments {
        public String[] profile;
        private String[] profile_type_info = new String[]{'profile','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'profile'};
    }
    public with sharing class CancelDeployResult {
        public Boolean done;
        public String id;
        private String[] done_type_info = new String[]{'done','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'done','id'};
    }
    public with sharing class CustomShortcut {
        public String description;
        public String eventName;
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] eventName_type_info = new String[]{'eventName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'description','eventName'};
    }
    public with sharing class LeadCriteriaBasedSharingRule {
        public String booleanFilter;
        public String description;
        public String leadAccessLevel;
        public String name;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] leadAccessLevel_type_info = new String[]{'leadAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'booleanFilter','description','leadAccessLevel','name'};
    }
    public with sharing class SynonymDictionary extends Metadata {
        public String type = 'SynonymDictionary';
        public String fullName;
        public MetadataService.SynonymGroup[] groups;
        public Boolean isProtected;
        public String label;
        private String[] groups_type_info = new String[]{'groups','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] isProtected_type_info = new String[]{'isProtected','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'groups','isProtected','label'};
    }
    public with sharing class CustomTab extends Metadata {
        public String type = 'CustomTab';
        public String fullName;
        public String auraComponent;
        public Boolean customObject;
        public String description;
        public String flexiPage;
        public Integer frameHeight;
        public Boolean hasSidebar;
        public String icon;
        public String label;
        public Boolean mobileReady;
        public String motif;
        public String page_x;
        public String scontrol;
        public String splashPageLink;
        public String url;
        public String urlEncodingKey;
        private String[] auraComponent_type_info = new String[]{'auraComponent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customObject_type_info = new String[]{'customObject','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] flexiPage_type_info = new String[]{'flexiPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] frameHeight_type_info = new String[]{'frameHeight','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] hasSidebar_type_info = new String[]{'hasSidebar','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] icon_type_info = new String[]{'icon','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] mobileReady_type_info = new String[]{'mobileReady','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] motif_type_info = new String[]{'motif','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scontrol_type_info = new String[]{'scontrol','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] splashPageLink_type_info = new String[]{'splashPageLink','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] url_type_info = new String[]{'url','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] urlEncodingKey_type_info = new String[]{'urlEncodingKey','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'auraComponent','customObject','description','flexiPage','frameHeight','hasSidebar','icon','label','mobileReady','motif','page_x','scontrol','splashPageLink','url','urlEncodingKey'};
    }
    public with sharing class Letterhead extends Metadata {
        public String type = 'Letterhead';
        public String fullName;
        public Boolean available;
        public String backgroundColor;
        public String bodyColor;
        public MetadataService.LetterheadLine bottomLine;
        public String description;
        public MetadataService.LetterheadHeaderFooter footer;
        public MetadataService.LetterheadHeaderFooter header;
        public MetadataService.LetterheadLine middleLine;
        public String name;
        public MetadataService.LetterheadLine topLine;
        private String[] available_type_info = new String[]{'available','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] backgroundColor_type_info = new String[]{'backgroundColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] bodyColor_type_info = new String[]{'bodyColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] bottomLine_type_info = new String[]{'bottomLine','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] footer_type_info = new String[]{'footer','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] header_type_info = new String[]{'header','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] middleLine_type_info = new String[]{'middleLine','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] topLine_type_info = new String[]{'topLine','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'available','backgroundColor','bodyColor','bottomLine','description','footer','header','middleLine','name','topLine'};
    }
    public with sharing class ReportTypeColumnTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class CustomPageWebLinkTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class EntitlementSettings extends Metadata {
        public String type = 'EntitlementSettings';
        public String fullName;
        public Boolean assetLookupLimitedToActiveEntitlementsOnAccount;
        public Boolean assetLookupLimitedToActiveEntitlementsOnContact;
        public Boolean assetLookupLimitedToSameAccount;
        public Boolean assetLookupLimitedToSameContact;
        public Boolean enableEntitlementVersioning;
        public Boolean enableEntitlements;
        public Boolean entitlementLookupLimitedToActiveStatus;
        public Boolean entitlementLookupLimitedToSameAccount;
        public Boolean entitlementLookupLimitedToSameAsset;
        public Boolean entitlementLookupLimitedToSameContact;
        private String[] assetLookupLimitedToActiveEntitlementsOnAccount_type_info = new String[]{'assetLookupLimitedToActiveEntitlementsOnAccount','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assetLookupLimitedToActiveEntitlementsOnContact_type_info = new String[]{'assetLookupLimitedToActiveEntitlementsOnContact','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assetLookupLimitedToSameAccount_type_info = new String[]{'assetLookupLimitedToSameAccount','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assetLookupLimitedToSameContact_type_info = new String[]{'assetLookupLimitedToSameContact','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableEntitlementVersioning_type_info = new String[]{'enableEntitlementVersioning','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enableEntitlements_type_info = new String[]{'enableEntitlements','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] entitlementLookupLimitedToActiveStatus_type_info = new String[]{'entitlementLookupLimitedToActiveStatus','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] entitlementLookupLimitedToSameAccount_type_info = new String[]{'entitlementLookupLimitedToSameAccount','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] entitlementLookupLimitedToSameAsset_type_info = new String[]{'entitlementLookupLimitedToSameAsset','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] entitlementLookupLimitedToSameContact_type_info = new String[]{'entitlementLookupLimitedToSameContact','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'assetLookupLimitedToActiveEntitlementsOnAccount','assetLookupLimitedToActiveEntitlementsOnContact','assetLookupLimitedToSameAccount','assetLookupLimitedToSameContact','enableEntitlementVersioning','enableEntitlements','entitlementLookupLimitedToActiveStatus','entitlementLookupLimitedToSameAccount','entitlementLookupLimitedToSameAsset','entitlementLookupLimitedToSameContact'};
    }
    public with sharing class FlowBaseElement {
        public MetadataService.FlowMetadataValue[] processMetadataValues;
        private String[] processMetadataValues_type_info = new String[]{'processMetadataValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'processMetadataValues'};
    }
    public with sharing class cancelDeployResponse_element {
        public MetadataService.CancelDeployResult result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class DocumentFolder extends Folder {
        public String type = 'DocumentFolder';
        public String fullName;
        public String accessType;
        public MetadataService.FolderShare[] folderShares;
        public String name;
        public String publicFolderAccess;
        public MetadataService.SharedTo sharedTo;
        private String[] accessType_type_info = new String[]{'accessType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] folderShares_type_info = new String[]{'folderShares','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] publicFolderAccess_type_info = new String[]{'publicFolderAccess','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sharedTo_type_info = new String[]{'sharedTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'accessType','folderShares','name','publicFolderAccess','sharedTo'};        
    }
    public with sharing class FlowConstant {
        public String dataType;
        public MetadataService.FlowElementReferenceOrValue value;
        private String[] dataType_type_info = new String[]{'dataType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'dataType','value'};
    }
    public with sharing class ChatterMobileSettings {
        public Boolean enablePushNotifications;
        private String[] enablePushNotifications_type_info = new String[]{'enablePushNotifications','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enablePushNotifications'};
    }
    public with sharing class CallCenterSection {
        public MetadataService.CallCenterItem[] items;
        public String label;
        public String name;
        private String[] items_type_info = new String[]{'items','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'items','label','name'};
    }
    public with sharing class PagesToOpen {
        public String[] pageToOpen;
        private String[] pageToOpen_type_info = new String[]{'pageToOpen','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'pageToOpen'};
    }
    public with sharing class ReportChart {
        public String backgroundColor1;
        public String backgroundColor2;
        public String backgroundFadeDir;
        public MetadataService.ChartSummary[] chartSummaries;
        public String chartType;
        public Boolean enableHoverLabels;
        public Boolean expandOthers;
        public String groupingColumn;
        public String legendPosition;
        public String location;
        public String secondaryGroupingColumn;
        public Boolean showAxisLabels;
        public Boolean showPercentage;
        public Boolean showTotal;
        public Boolean showValues;
        public String size;
        public Double summaryAxisManualRangeEnd;
        public Double summaryAxisManualRangeStart;
        public String summaryAxisRange;
        public String textColor;
        public Integer textSize;
        public String title;
        public String titleColor;
        public Integer titleSize;
        private String[] backgroundColor1_type_info = new String[]{'backgroundColor1','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] backgroundColor2_type_info = new String[]{'backgroundColor2','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] backgroundFadeDir_type_info = new String[]{'backgroundFadeDir','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] chartSummaries_type_info = new String[]{'chartSummaries','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] chartType_type_info = new String[]{'chartType','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enableHoverLabels_type_info = new String[]{'enableHoverLabels','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] expandOthers_type_info = new String[]{'expandOthers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] groupingColumn_type_info = new String[]{'groupingColumn','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] legendPosition_type_info = new String[]{'legendPosition','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] location_type_info = new String[]{'location','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] secondaryGroupingColumn_type_info = new String[]{'secondaryGroupingColumn','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showAxisLabels_type_info = new String[]{'showAxisLabels','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showPercentage_type_info = new String[]{'showPercentage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showTotal_type_info = new String[]{'showTotal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showValues_type_info = new String[]{'showValues','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] size_type_info = new String[]{'size','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryAxisManualRangeEnd_type_info = new String[]{'summaryAxisManualRangeEnd','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryAxisManualRangeStart_type_info = new String[]{'summaryAxisManualRangeStart','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryAxisRange_type_info = new String[]{'summaryAxisRange','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] textColor_type_info = new String[]{'textColor','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] textSize_type_info = new String[]{'textSize','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] title_type_info = new String[]{'title','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] titleColor_type_info = new String[]{'titleColor','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] titleSize_type_info = new String[]{'titleSize','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'backgroundColor1','backgroundColor2','backgroundFadeDir','chartSummaries','chartType','enableHoverLabels','expandOthers','groupingColumn','legendPosition','location','secondaryGroupingColumn','showAxisLabels','showPercentage','showTotal','showValues','size','summaryAxisManualRangeEnd','summaryAxisManualRangeStart','summaryAxisRange','textColor','textSize','title','titleColor','titleSize'};
    }
    public with sharing class checkRetrieveStatusResponse_element {
        public MetadataService.RetrieveResult result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class KnowledgeCaseSettings {
        public String articlePDFCreationProfile;
        public MetadataService.KnowledgeSitesSettings articlePublicSharingSites;
        public MetadataService.KnowledgeSitesSettings articlePublicSharingSitesChatterAnswers;
        public String assignTo;
        public String customizationClass;
        public String defaultContributionArticleType;
        public String editor;
        public Boolean enableArticleCreation;
        public Boolean enableArticlePublicSharingSites;
        public Boolean useProfileForPDFCreation;
        private String[] articlePDFCreationProfile_type_info = new String[]{'articlePDFCreationProfile','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] articlePublicSharingSites_type_info = new String[]{'articlePublicSharingSites','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] articlePublicSharingSitesChatterAnswers_type_info = new String[]{'articlePublicSharingSitesChatterAnswers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] assignTo_type_info = new String[]{'assignTo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customizationClass_type_info = new String[]{'customizationClass','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultContributionArticleType_type_info = new String[]{'defaultContributionArticleType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] editor_type_info = new String[]{'editor','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableArticleCreation_type_info = new String[]{'enableArticleCreation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableArticlePublicSharingSites_type_info = new String[]{'enableArticlePublicSharingSites','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] useProfileForPDFCreation_type_info = new String[]{'useProfileForPDFCreation','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'articlePDFCreationProfile','articlePublicSharingSites','articlePublicSharingSitesChatterAnswers','assignTo','customizationClass','defaultContributionArticleType','editor','enableArticleCreation','enableArticlePublicSharingSites','useProfileForPDFCreation'};
    }
    public with sharing class SharingReason extends Metadata {
        public String type = 'SharingReason';
        public String fullName;
        public String label;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'label'};
    }
    public with sharing class ProfileFieldLevelSecurity {
        public Boolean editable;
        public String field;
        public Boolean readable;
        private String[] editable_type_info = new String[]{'editable','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] readable_type_info = new String[]{'readable','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'editable','field','readable'};
    }
    public with sharing class CompactLayout extends Metadata {
        public String type = 'CompactLayout';
        public String fullName;
        public String[] fields;
        public String label;
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'fields','label'};
    }
    public with sharing class MiniLayout {
        public String[] fields;
        public MetadataService.RelatedListItem[] relatedLists;
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] relatedLists_type_info = new String[]{'relatedLists','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fields','relatedLists'};
    }
    public with sharing class ReportBucketFieldSourceValue {
        public String from_x;
        public String sourceValue;
        public String to;
        private String[] from_x_type_info = new String[]{'from','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sourceValue_type_info = new String[]{'sourceValue','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] to_type_info = new String[]{'to','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'from_x','sourceValue','to'};
    }
    public with sharing class UpsertResult {
        public Boolean created;
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
        private String[] created_type_info = new String[]{'created','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] errors_type_info = new String[]{'errors','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fullName_type_info = new String[]{'fullName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'created','errors','fullName','success'};
    }
    public with sharing class AccessMapping {
        public String accessLevel;
        public String object_x;
        public String objectField;
        public String userField;
        private String[] accessLevel_type_info = new String[]{'accessLevel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] object_x_type_info = new String[]{'object','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] objectField_type_info = new String[]{'objectField','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] userField_type_info = new String[]{'userField','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'accessLevel','object_x','objectField','userField'};
    }
    public with sharing class CustomDataTypeComponent {
        public String developerSuffix;
        public Boolean enforceFieldRequiredness;
        public String label;
        public Integer length;
        public Integer precision;
        public Integer scale;
        public String sortOrder;
        public Integer sortPriority;
        public String type_x;
        private String[] developerSuffix_type_info = new String[]{'developerSuffix','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] enforceFieldRequiredness_type_info = new String[]{'enforceFieldRequiredness','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] length_type_info = new String[]{'length','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] precision_type_info = new String[]{'precision','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scale_type_info = new String[]{'scale','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortOrder_type_info = new String[]{'sortOrder','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sortPriority_type_info = new String[]{'sortPriority','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'developerSuffix','enforceFieldRequiredness','label','length','precision','scale','sortOrder','sortPriority','type_x'};
    }
    public with sharing class CustomObjectTranslation extends Metadata {
        public String type = 'CustomObjectTranslation';
        public String fullName;
        public MetadataService.ObjectNameCaseValue[] caseValues;
        public MetadataService.CustomFieldTranslation[] fields;
        public String gender;
        public MetadataService.LayoutTranslation[] layouts;
        public String nameFieldLabel;
        public MetadataService.QuickActionTranslation[] quickActions;
        public MetadataService.RecordTypeTranslation[] recordTypes;
        public MetadataService.SharingReasonTranslation[] sharingReasons;
        public MetadataService.StandardFieldTranslation[] standardFields;
        public String startsWith;
        public MetadataService.ValidationRuleTranslation[] validationRules;
        public MetadataService.WebLinkTranslation[] webLinks;
        public MetadataService.WorkflowTaskTranslation[] workflowTasks;
        private String[] caseValues_type_info = new String[]{'caseValues','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fields_type_info = new String[]{'fields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] gender_type_info = new String[]{'gender','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] layouts_type_info = new String[]{'layouts','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] nameFieldLabel_type_info = new String[]{'nameFieldLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] quickActions_type_info = new String[]{'quickActions','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] recordTypes_type_info = new String[]{'recordTypes','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] sharingReasons_type_info = new String[]{'sharingReasons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] standardFields_type_info = new String[]{'standardFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] startsWith_type_info = new String[]{'startsWith','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] validationRules_type_info = new String[]{'validationRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] webLinks_type_info = new String[]{'webLinks','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] workflowTasks_type_info = new String[]{'workflowTasks','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'caseValues','fields','gender','layouts','nameFieldLabel','quickActions','recordTypes','sharingReasons','standardFields','startsWith','validationRules','webLinks','workflowTasks'};
    }
    public with sharing class CustomApplication extends Metadata {
        public String type = 'CustomApplication';
        public String fullName;
        public MetadataService.CustomApplicationComponents customApplicationComponents;
        public String defaultLandingTab;
        public String description;
        public String detailPageRefreshMethod;
        public MetadataService.DomainWhitelist domainWhitelist;
        public Boolean enableKeyboardShortcuts;
        public Boolean enableMultiMonitorComponents;
        public Boolean isServiceCloudConsole;
        public MetadataService.KeyboardShortcuts keyboardShortcuts;
        public String label;
        public MetadataService.ListPlacement listPlacement;
        public String listRefreshMethod;
        public MetadataService.LiveAgentConfig liveAgentConfig;
        public String logo;
        public MetadataService.PushNotifications pushNotifications;
        public Boolean saveUserSessions;
        public String[] tab;
        public MetadataService.WorkspaceMappings workspaceMappings;
        private String[] customApplicationComponents_type_info = new String[]{'customApplicationComponents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultLandingTab_type_info = new String[]{'defaultLandingTab','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] detailPageRefreshMethod_type_info = new String[]{'detailPageRefreshMethod','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] domainWhitelist_type_info = new String[]{'domainWhitelist','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableKeyboardShortcuts_type_info = new String[]{'enableKeyboardShortcuts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableMultiMonitorComponents_type_info = new String[]{'enableMultiMonitorComponents','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isServiceCloudConsole_type_info = new String[]{'isServiceCloudConsole','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] keyboardShortcuts_type_info = new String[]{'keyboardShortcuts','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] listPlacement_type_info = new String[]{'listPlacement','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] listRefreshMethod_type_info = new String[]{'listRefreshMethod','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] liveAgentConfig_type_info = new String[]{'liveAgentConfig','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] logo_type_info = new String[]{'logo','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] pushNotifications_type_info = new String[]{'pushNotifications','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] saveUserSessions_type_info = new String[]{'saveUserSessions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] tab_type_info = new String[]{'tab','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] workspaceMappings_type_info = new String[]{'workspaceMappings','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'customApplicationComponents','defaultLandingTab','description','detailPageRefreshMethod','domainWhitelist','enableKeyboardShortcuts','enableMultiMonitorComponents','isServiceCloudConsole','keyboardShortcuts','label','listPlacement','listRefreshMethod','liveAgentConfig','logo','pushNotifications','saveUserSessions','tab','workspaceMappings'};
    }
    public with sharing class ReportAggregate {
        public String acrossGroupingContext;
        public String calculatedFormula;
        public String datatype;
        public String description;
        public String developerName;
        public String downGroupingContext;
        public Boolean isActive;
        public Boolean isCrossBlock;
        public String masterLabel;
        public String reportType;
        public Integer scale;
        private String[] acrossGroupingContext_type_info = new String[]{'acrossGroupingContext','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] calculatedFormula_type_info = new String[]{'calculatedFormula','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] datatype_type_info = new String[]{'datatype','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] developerName_type_info = new String[]{'developerName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] downGroupingContext_type_info = new String[]{'downGroupingContext','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isCrossBlock_type_info = new String[]{'isCrossBlock','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] masterLabel_type_info = new String[]{'masterLabel','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] reportType_type_info = new String[]{'reportType','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scale_type_info = new String[]{'scale','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'acrossGroupingContext','calculatedFormula','datatype','description','developerName','downGroupingContext','isActive','isCrossBlock','masterLabel','reportType','scale'};
    }
    public with sharing class AgentConfigUserAssignments {
        public String[] user_x;
        private String[] user_x_type_info = new String[]{'user','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'user_x'};
    }
    public with sharing class DashboardMobileSettings {
        public Boolean enableDashboardIPadApp;
        private String[] enableDashboardIPadApp_type_info = new String[]{'enableDashboardIPadApp','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'enableDashboardIPadApp'};
    }
    public with sharing class NetworkMemberGroup {
        public String[] permissionSet;
        public String[] profile;
        private String[] permissionSet_type_info = new String[]{'permissionSet','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] profile_type_info = new String[]{'profile','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'permissionSet','profile'};
    }
    public with sharing class CampaignSharingRules {
        public MetadataService.CampaignCriteriaBasedSharingRule[] criteriaBasedRules;
        public MetadataService.CampaignOwnerSharingRule[] ownerRules;
        private String[] criteriaBasedRules_type_info = new String[]{'criteriaBasedRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] ownerRules_type_info = new String[]{'ownerRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaBasedRules','ownerRules'};
    }
    public with sharing class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
    public with sharing class Territory2 extends Metadata {
        public String type = 'Territory2';
        public String fullName;
        public String accountAccessLevel;
        public String caseAccessLevel;
        public String contactAccessLevel;
        public MetadataService.FieldValue[] customFields;
        public String description;
        public String name;
        public String opportunityAccessLevel;
        public String parentTerritory;
        public MetadataService.Territory2RuleAssociation[] ruleAssociations;
        public String territory2Type;
        private String[] accountAccessLevel_type_info = new String[]{'accountAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] caseAccessLevel_type_info = new String[]{'caseAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] contactAccessLevel_type_info = new String[]{'contactAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customFields_type_info = new String[]{'customFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] opportunityAccessLevel_type_info = new String[]{'opportunityAccessLevel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] parentTerritory_type_info = new String[]{'parentTerritory','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] ruleAssociations_type_info = new String[]{'ruleAssociations','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] territory2Type_type_info = new String[]{'territory2Type','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'accountAccessLevel','caseAccessLevel','contactAccessLevel','customFields','description','name','opportunityAccessLevel','parentTerritory','ruleAssociations','territory2Type'};
    }
    public with sharing class Container {
        public Integer height;
        public Boolean isContainerAutoSizeEnabled;
        public String region;
        public MetadataService.SidebarComponent[] sidebarComponents;
        public String style;
        public String unit;
        public Integer width;
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isContainerAutoSizeEnabled_type_info = new String[]{'isContainerAutoSizeEnabled','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] region_type_info = new String[]{'region','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] sidebarComponents_type_info = new String[]{'sidebarComponents','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] style_type_info = new String[]{'style','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] unit_type_info = new String[]{'unit','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'height','isContainerAutoSizeEnabled','region','sidebarComponents','style','unit','width'};
    }
    public with sharing class FindSimilarOppFilter {
        public String[] similarOpportunitiesDisplayColumns;
        public String[] similarOpportunitiesMatchFields;
        private String[] similarOpportunitiesDisplayColumns_type_info = new String[]{'similarOpportunitiesDisplayColumns','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] similarOpportunitiesMatchFields_type_info = new String[]{'similarOpportunitiesMatchFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'similarOpportunitiesDisplayColumns','similarOpportunitiesMatchFields'};
    }
    public with sharing class Community extends Metadata {
        public String type = 'Community';
        public String fullName;
        public Boolean active;
        public String communityFeedPage;
        public String description;
        public String emailFooterDocument;
        public String emailHeaderDocument;
        public String emailNotificationUrl;
        public Boolean enableChatterAnswers;
        public Boolean enablePrivateQuestions;
        public String expertsGroup;
        public String portal;
        public MetadataService.ReputationLevels reputationLevels;
        public Boolean showInPortal;
        public String site;
        private String[] active_type_info = new String[]{'active','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] communityFeedPage_type_info = new String[]{'communityFeedPage','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailFooterDocument_type_info = new String[]{'emailFooterDocument','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailHeaderDocument_type_info = new String[]{'emailHeaderDocument','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emailNotificationUrl_type_info = new String[]{'emailNotificationUrl','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enableChatterAnswers_type_info = new String[]{'enableChatterAnswers','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] enablePrivateQuestions_type_info = new String[]{'enablePrivateQuestions','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] expertsGroup_type_info = new String[]{'expertsGroup','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] portal_type_info = new String[]{'portal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reputationLevels_type_info = new String[]{'reputationLevels','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showInPortal_type_info = new String[]{'showInPortal','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] site_type_info = new String[]{'site','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','communityFeedPage','description','emailFooterDocument','emailHeaderDocument','emailNotificationUrl','enableChatterAnswers','enablePrivateQuestions','expertsGroup','portal','reputationLevels','showInPortal','site'};
    }
    public with sharing class DeleteResult {
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fullName_type_info = new String[]{'fullName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'errors','fullName','success'};
    }
    public with sharing class LayoutItem {
        public String behavior;
        public String canvas;
        public String component;
        public String customLink;
        public Boolean emptySpace;
        public String field;
        public Integer height;
        public String page_x;
        public MetadataService.ReportChartComponentLayoutItem reportChartComponent;
        public String scontrol;
        public Boolean showLabel;
        public Boolean showScrollbars;
        public String width;
        private String[] behavior_type_info = new String[]{'behavior','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] canvas_type_info = new String[]{'canvas','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] component_type_info = new String[]{'component','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customLink_type_info = new String[]{'customLink','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] emptySpace_type_info = new String[]{'emptySpace','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] field_type_info = new String[]{'field','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] height_type_info = new String[]{'height','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] page_x_type_info = new String[]{'page','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reportChartComponent_type_info = new String[]{'reportChartComponent','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scontrol_type_info = new String[]{'scontrol','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showLabel_type_info = new String[]{'showLabel','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] showScrollbars_type_info = new String[]{'showScrollbars','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] width_type_info = new String[]{'width','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'behavior','canvas','component','customLink','emptySpace','field','height','page_x','reportChartComponent','scontrol','showLabel','showScrollbars','width'};
    }
    public with sharing class SharingReasonTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class SharingSet extends Metadata {
        public String type = 'SharingSet';
        public String fullName;
        public MetadataService.AccessMapping[] accessMappings;
        public String description;
        public String name;
        public String[] profiles;
        private String[] accessMappings_type_info = new String[]{'accessMappings','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] profiles_type_info = new String[]{'profiles','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','https://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'accessMappings','description','name','profiles'};
    }
    public with sharing class checkDeployStatusResponse_element {
        public MetadataService.DeployResult result;
        private String[] result_type_info = new String[]{'result','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public with sharing class ReportColorRange {
        public String aggregate;
        public String columnName;
        public Double highBreakpoint;
        public String highColor;
        public Double lowBreakpoint;
        public String lowColor;
        public String midColor;
        private String[] aggregate_type_info = new String[]{'aggregate','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] columnName_type_info = new String[]{'columnName','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] highBreakpoint_type_info = new String[]{'highBreakpoint','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] highColor_type_info = new String[]{'highColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lowBreakpoint_type_info = new String[]{'lowBreakpoint','https://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lowColor_type_info = new String[]{'lowColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] midColor_type_info = new String[]{'midColor','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'aggregate','columnName','highBreakpoint','highColor','lowBreakpoint','lowColor','midColor'};
    }
    public with sharing class SearchLayouts {
        public String[] customTabListAdditionalFields;
        public String[] excludedStandardButtons;
        public String[] listViewButtons;
        public String[] lookupDialogsAdditionalFields;
        public String[] lookupFilterFields;
        public String[] lookupPhoneDialogsAdditionalFields;
        public String[] searchFilterFields;
        public String[] searchResultsAdditionalFields;
        public String[] searchResultsCustomButtons;
        private String[] customTabListAdditionalFields_type_info = new String[]{'customTabListAdditionalFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] excludedStandardButtons_type_info = new String[]{'excludedStandardButtons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] listViewButtons_type_info = new String[]{'listViewButtons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] lookupDialogsAdditionalFields_type_info = new String[]{'lookupDialogsAdditionalFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] lookupFilterFields_type_info = new String[]{'lookupFilterFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] lookupPhoneDialogsAdditionalFields_type_info = new String[]{'lookupPhoneDialogsAdditionalFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] searchFilterFields_type_info = new String[]{'searchFilterFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] searchResultsAdditionalFields_type_info = new String[]{'searchResultsAdditionalFields','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] searchResultsCustomButtons_type_info = new String[]{'searchResultsCustomButtons','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'customTabListAdditionalFields','excludedStandardButtons','listViewButtons','lookupDialogsAdditionalFields','lookupFilterFields','lookupPhoneDialogsAdditionalFields','searchFilterFields','searchResultsAdditionalFields','searchResultsCustomButtons'};
    }
    public with sharing class QuickActionTranslation {
        public String label;
        public String name;
        private String[] label_type_info = new String[]{'label','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','https://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }
    public with sharing class AccountSharingRules {
        public MetadataService.AccountCriteriaBasedSharingRule[] criteriaBasedRules;
        public MetadataService.AccountOwnerSharingRule[] ownerRules;
        private String[] criteriaBasedRules_type_info = new String[]{'criteriaBasedRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] ownerRules_type_info = new String[]{'ownerRules','https://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'criteriaBasedRules','ownerRules'};
    }
    public with sharing class MetadataPort {
        public String endpoint_x = 'callout:ApexMDApi'+ '/services/Soap/m/32.0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public MetadataService.SessionHeader_element SessionHeader;
        public MetadataService.DebuggingInfo_element DebuggingInfo;
        public MetadataService.CallOptions_element CallOptions;
        public MetadataService.DebuggingHeader_element DebuggingHeader;
        private String SessionHeader_hns = 'SessionHeader=https://soap.sforce.com/2006/04/metadata';
        private String DebuggingInfo_hns = 'DebuggingInfo=https://soap.sforce.com/2006/04/metadata';
        private String CallOptions_hns = 'CallOptions=https://soap.sforce.com/2006/04/metadata';
        private String DebuggingHeader_hns = 'DebuggingHeader=https://soap.sforce.com/2006/04/metadata';
        private String[] ns_map_type_info = new String[]{'https://soap.sforce.com/2006/04/metadata', 'MetadataService'};
        public MetadataService.SaveResult[] updateMetadata(MetadataService.Metadata[] metadata) {
            MetadataService.updateMetadata_element request_x = new MetadataService.updateMetadata_element();
            request_x.metadata = metadata;
            MetadataService.updateMetadataResponse_element response_x;
            Map<String, MetadataService.updateMetadataResponse_element> response_map_x = new Map<String, MetadataService.updateMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'updateMetadata',
              'https://soap.sforce.com/2006/04/metadata',
              'updateMetadataResponse',
              'MetadataService.updateMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.AsyncResult retrieve(MetadataService.RetrieveRequest retrieveRequest) {
            MetadataService.retrieve_element request_x = new MetadataService.retrieve_element();
            request_x.retrieveRequest = retrieveRequest;
            MetadataService.retrieveResponse_element response_x;
            Map<String, MetadataService.retrieveResponse_element> response_map_x = new Map<String, MetadataService.retrieveResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'retrieve',
              'https://soap.sforce.com/2006/04/metadata',
              'retrieveResponse',
              'MetadataService.retrieveResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.DeployResult checkDeployStatus(String asyncProcessId,Boolean includeDetails) {
            MetadataService.checkDeployStatus_element request_x = new MetadataService.checkDeployStatus_element();
            request_x.asyncProcessId = asyncProcessId;
            request_x.includeDetails = includeDetails;
            MetadataService.checkDeployStatusResponse_element response_x;
            Map<String, MetadataService.checkDeployStatusResponse_element> response_map_x = new Map<String, MetadataService.checkDeployStatusResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'checkDeployStatus',
              'https://soap.sforce.com/2006/04/metadata',
              'checkDeployStatusResponse',
              'MetadataService.checkDeployStatusResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.SaveResult renameMetadata(String type_x,String oldFullName,String newFullName) {
            MetadataService.renameMetadata_element request_x = new MetadataService.renameMetadata_element();
            request_x.type_x = type_x;
            request_x.oldFullName = oldFullName;
            request_x.newFullName = newFullName;
            MetadataService.renameMetadataResponse_element response_x;
            Map<String, MetadataService.renameMetadataResponse_element> response_map_x = new Map<String, MetadataService.renameMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'renameMetadata',
              'https://soap.sforce.com/2006/04/metadata',
              'renameMetadataResponse',
              'MetadataService.renameMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.CancelDeployResult cancelDeploy(String String_x) {
            MetadataService.cancelDeploy_element request_x = new MetadataService.cancelDeploy_element();
            request_x.String_x = String_x;
            MetadataService.cancelDeployResponse_element response_x;
            Map<String, MetadataService.cancelDeployResponse_element> response_map_x = new Map<String, MetadataService.cancelDeployResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'cancelDeploy',
              'https://soap.sforce.com/2006/04/metadata',
              'cancelDeployResponse',
              'MetadataService.cancelDeployResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.FileProperties[] listMetadata(MetadataService.ListMetadataQuery[] queries,Double asOfVersion) {
            MetadataService.listMetadata_element request_x = new MetadataService.listMetadata_element();
            request_x.queries = queries;
            request_x.asOfVersion = asOfVersion;
            MetadataService.listMetadataResponse_element response_x;
            Map<String, MetadataService.listMetadataResponse_element> response_map_x = new Map<String, MetadataService.listMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'listMetadata',
              'https://soap.sforce.com/2006/04/metadata',
              'listMetadataResponse',
              'MetadataService.listMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.DeleteResult[] deleteMetadata(String type_x,String[] fullNames) {
            MetadataService.deleteMetadata_element request_x = new MetadataService.deleteMetadata_element();
            request_x.type_x = type_x;
            request_x.fullNames = fullNames;
            MetadataService.deleteMetadataResponse_element response_x;
            Map<String, MetadataService.deleteMetadataResponse_element> response_map_x = new Map<String, MetadataService.deleteMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'deleteMetadata',
              'https://soap.sforce.com/2006/04/metadata',
              'deleteMetadataResponse',
              'MetadataService.deleteMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.UpsertResult[] upsertMetadata(MetadataService.Metadata[] metadata) {
            MetadataService.upsertMetadata_element request_x = new MetadataService.upsertMetadata_element();
            request_x.metadata = metadata;
            MetadataService.upsertMetadataResponse_element response_x;
            Map<String, MetadataService.upsertMetadataResponse_element> response_map_x = new Map<String, MetadataService.upsertMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'upsertMetadata',
              'https://soap.sforce.com/2006/04/metadata',
              'upsertMetadataResponse',
              'MetadataService.upsertMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.SaveResult[] createMetadata(MetadataService.Metadata[] metadata) {
            MetadataService.createMetadata_element request_x = new MetadataService.createMetadata_element();
            request_x.metadata = metadata;
            MetadataService.createMetadataResponse_element response_x;
            Map<String, MetadataService.createMetadataResponse_element> response_map_x = new Map<String, MetadataService.createMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'createMetadata',
              'https://soap.sforce.com/2006/04/metadata',
              'createMetadataResponse',
              'MetadataService.createMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.RetrieveResult checkRetrieveStatus(String asyncProcessId) {
            MetadataService.checkRetrieveStatus_element request_x = new MetadataService.checkRetrieveStatus_element();
            request_x.asyncProcessId = asyncProcessId;
            MetadataService.checkRetrieveStatusResponse_element response_x;
            Map<String, MetadataService.checkRetrieveStatusResponse_element> response_map_x = new Map<String, MetadataService.checkRetrieveStatusResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'checkRetrieveStatus',
              'https://soap.sforce.com/2006/04/metadata',
              'checkRetrieveStatusResponse',
              'MetadataService.checkRetrieveStatusResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.IReadResult readMetadata(String type_x,String[] fullNames) {
            MetadataService.readMetadata_element request_x = new MetadataService.readMetadata_element();
            request_x.type_x = type_x;
            request_x.fullNames = fullNames;
            MetadataService.IReadResponseElement response_x;
            Map<String, MetadataService.IReadResponseElement> response_map_x = new Map<String, MetadataService.IReadResponseElement>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'readMetadata',
              'https://soap.sforce.com/2006/04/metadata',
              'readMetadataResponse',
              'MetadataService.read' + type_x + 'Response_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getResult();
        }
        public MetadataService.DescribeMetadataResult describeMetadata(Double asOfVersion) {
            MetadataService.describeMetadata_element request_x = new MetadataService.describeMetadata_element();
            request_x.asOfVersion = asOfVersion;
            MetadataService.describeMetadataResponse_element response_x;
            Map<String, MetadataService.describeMetadataResponse_element> response_map_x = new Map<String, MetadataService.describeMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'describeMetadata',
              'https://soap.sforce.com/2006/04/metadata',
              'describeMetadataResponse',
              'MetadataService.describeMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.AsyncResult deploy(String ZipFile,MetadataService.DeployOptions DeployOptions) {
            MetadataService.deploy_element request_x = new MetadataService.deploy_element();
            request_x.ZipFile = ZipFile;
            request_x.DeployOptions = DeployOptions;
            MetadataService.deployResponse_element response_x;
            Map<String, MetadataService.deployResponse_element> response_map_x = new Map<String, MetadataService.deployResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'https://soap.sforce.com/2006/04/metadata',
              'deploy',
              'https://soap.sforce.com/2006/04/metadata',
              'deployResponse',
              'MetadataService.deployResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
}