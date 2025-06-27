/**
 * Created by Atul.N on 05-05-2020.
 * Wrapper Class to Expose API.....
 */

global abstract with sharing class CaptureFormResponseWrapper {

    global static CaptureForm captureForm{get;set;}
    global static List<CaptureItemResponse__c> cptureItemRespLst{get;set;}

    global with sharing class CaptureForm{
        global Id formId{get;set;}
        global String scoreHolderFieldAPIName{get;set;}
        global String objectType{get;set;}
        global List<CaptureSection> sections{get;set;}
        global Decimal totalScore{get;set;} 
    }

    global with sharing class CaptureSection{
        global String sectionId{get;set;}
        global String sectionName{get;set;}
        global Integer order{get;set;}
        global List<CaptureField> fields{get;set;}
    }

    global with sharing class CaptureField{
        global Id sectionId{get;set;}
        global String questionName{get;set;}
        global String questionLabel{get;set;}
        global String dataType{get;set;}
        global String commentType{get;set;}
        global Decimal maxScore{get;set;}
        global Integer order{get;set;}
        global Boolean isRequiredSave{get;set;}
        global Boolean isRequiredSubmit{get;set;}
        global Id parentId{get;set;}
        global String questionApplicable{get;set;}

        global String comments{get;set;}
        global Decimal actualScore{get;set;}
        global String response{get;set;}   
        global String textResponse{get;set;}  
        global Boolean booleanResponse{get;set;}
        global Decimal currencyResponse{get;set;}
        global Decimal pecentResponse{get;set;}
        global Decimal numberResponse{get;set;}
        global Date dateResponse{get;set;}
        global Boolean isBlank{get;set;}
    }

    global static CaptureForm getFormResponse(Id formId, Id parentId){
           String formStrIdVal =  String.valueOf(formId);
           String parentStrIdVal = String.valueOf(parentId);

        List<CaptureItemResponse__c> itemsResponseList = new List<CaptureItemResponse__c>();
        if(Schema.sObjectType.CaptureItemResponse__c.isAccessible()){
            itemsResponseList = [Select Id, Answer__c, CheckboxAnswer__c, CurrencyAnswer__c,
                DateAnswer__c, NumberAnswer__c, PercentAnswer__c, RadioAnswer__c, RichTextAnswer__c,
                QuestionComments__c, Score__c, ParentId__c,
                CaptureItem__c, CaptureItem__r.CaptureSection__c,
                CaptureItem__r.CommentApplicable__c, CaptureItem__r.MaxScore__c,
                CaptureItem__r.Order__c, CaptureItem__r.QuestionRichText__c, CaptureItem__r.Type__c, CaptureItem__r.QuestionApplicable__c
                from CaptureItemResponse__c 
                Where CaptureItem__r.CaptureSection__r.CaptureForm__c = :formStrIdVal AND ParentId__c = : parentStrIdVal  WITH USER_MODE ORDER BY CaptureItem__r.Order__c]; //sf review
        }
        List<CaptureField> formFields = new List<CaptureField>();
        Map<Id, List<CaptureField>> formFieldSectionMap = new Map<Id, List<CaptureField>>();

        cptureItemRespLst = itemsResponseList;
        if(cptureItemRespLst.size() < 1){
            throw new CustomExceptions.RequiredException('Response Not Present In Form For That Specific Parent Record...');
        }
        if(itemsResponseList.size() > 0){
            for(CaptureItemResponse__c response: itemsResponseList){
                CaptureField field = new CaptureField();
                field.questionName = response.CaptureItem__c;
                field.questionLabel = response.CaptureItem__r.QuestionRichText__c;
                field.actualScore = response.Score__c;
                field.dataType = response.CaptureItem__r.Type__c;
                field.order = Integer.valueOf(response.CaptureItem__r.Order__c);
                field.maxScore = response.CaptureItem__r.MaxScore__c;
                field.commentType = response.CaptureItem__r.CommentApplicable__c;
                field.sectionId = response.CaptureItem__r.CaptureSection__c;
                field.parentId = response.ParentId__c;
                field.comments = response.QuestionComments__c;
                field.questionApplicable = response.CaptureItem__r.QuestionApplicable__c;
                if(field.questionApplicable == 'Required to save'){
                    field.isRequiredSave = true;
                }else{
                    field.isRequiredSave = false;
                }


                if(field.questionApplicable == 'Required to submit'){
                    field.isRequiredSubmit = true;
                }else{
                    field.isRequiredSubmit = false;
                }

                switch on field.dataType{
                    when 'Checkbox'{
                        field.booleanResponse = response.CheckboxAnswer__c;
                        field.response = String.valueOf(field.booleanResponse);
                    }
                    when 'Radio'{
                        field.textResponse = response.RadioAnswer__c;
                        field.response = String.valueOf(field.textResponse);
                    }
                    when 'Currency'{
                        field.currencyResponse = response.CurrencyAnswer__c;
                        field.response = String.valueOf(field.currencyResponse);
                    }
                    when 'Number'{
                        field.numberResponse = response.NumberAnswer__c;
                        field.response = String.valueOf(field.numberResponse);
                    }
                    when 'Date'{
                        field.dateResponse = response.DateAnswer__c;
                        field.response = String.valueOf(field.dateResponse);
                    }
                    when 'Percent'{
                        field.pecentResponse = response.PercentAnswer__c;
                        field.response = String.valueOf(field.pecentResponse);
                    }
                    when 'Rich Text Area'{
                        field.textResponse = response.RichTextAnswer__c;
                        field.response = String.valueOf(field.textResponse);
                    }
                    when else{
                        field.textResponse = response.Answer__c;
                        field.response = String.valueOf(field.textResponse);
                    }
                }

                field.isBlank = false;
                if(String.isBlank(field.response) || field.booleanResponse == false){
                    field.isBlank = true;
                }
                List<CaptureField> fldsLst = formFieldSectionMap.get(field.sectionId);
                if(fldsLst == null){
                    fldsLst = new List<CaptureField>();
                }
                fldsLst.add(field);
                formFieldSectionMap.put(field.sectionId, fldsLst);
            }
        }


        List<CaptureSection__c> sections = new List<CaptureSection__c>();
        if(Schema.sObjectType.CaptureSection__c.isAccessible()){
            sections = [Select Id, Name__c, Order__c, CaptureForm__c,
                    CaptureForm__r.Name__c, CaptureForm__r.ObjectType__c, CaptureForm__r.ScoreHolderAPIName__c
            from CaptureSection__c Where CaptureForm__c = :formId  WITH USER_MODE]; //sf review
        }

        captureForm = new CaptureForm();

        List<CaptureSection> sectionList = new List<CaptureSection>();

        if(sections.size() > 0){
            for(CaptureSection__c cpSectionVal: sections){
                CaptureSection sectionWrapper = new CaptureSection();
                sectionWrapper.sectionId = cpSectionVal.Id;
                sectionWrapper.sectionName = cpSectionVal.Name__c;
                sectionWrapper.order = Integer.valueOf(cpSectionVal.Order__c);
                sectionWrapper.fields = formFieldSectionMap.get(cpSectionVal.Id);
                sectionList.add(sectionWrapper);
            }

            captureForm.formId = sections[0].CaptureForm__c;
            captureForm.scoreHolderFieldAPIName = sections[0].CaptureForm__r.ScoreHolderAPIName__c;
            captureForm.objectType = sections[0].CaptureForm__r.ObjectType__c;
            captureForm.sections = sectionList;
        }
        return captureForm;
    }

    global static Map<String,Decimal> getPercentFormFilled(Id formId, Id parentId){
        Map<String,Decimal> totalPercentFieldMap = new Map<String,Decimal>();
        CaptureForm cpForm = getFormResponse(formId,parentId);
        Double totalFieldCnt =0.0;
        Double requiredSaveFieldCnt =0.0;
        Double requiredSubmitFieldCnt =0.0;
        List<String> totalFieldList = new List<String>();
        Set<String> requiredForSaveSet = new Set<String>();
        Set<String> requiredForSubmitSet = new Set<String>();
        if(cpForm != null){
            for(CaptureSection cpSectionVal: cpForm.sections){
                for(CaptureField cpFieldVal: cpSectionVal.fields){
                    totalFieldList.add(cpFieldVal.questionName);

                    if(cpFieldVal.questionApplicable == 'Required to save'){
                        requiredForSaveSet.add(cpFieldVal.questionName);
                    }

                    if(cpFieldVal.questionApplicable == 'Required to submit'){
                        requiredForSubmitSet.add(cpFieldVal.questionName);
                    }
                }
            }

            if(totalFieldList.size() > 0){
                for(String qestionName: totalFieldList){
                    totalFieldCnt++;

                    if(requiredForSaveSet.contains(qestionName)){
                        requiredSaveFieldCnt++;
                    }

                    if(requiredForSubmitSet.contains(qestionName)){
                        requiredSubmitFieldCnt++;
                    }
                }
            }

            Decimal totalFieldPercentage = (totalFieldList.size() > 0) ? 100*totalFieldCnt/totalFieldList.size() : 100;
            Decimal requiredForSavePercentage = (requiredForSaveSet.size() > 0) ? 100*requiredSaveFieldCnt/requiredForSaveSet.size() : 100;
            Decimal requiredForSubmitPercentage = (requiredForSubmitSet.size() > 0) ? 100*requiredSubmitFieldCnt/requiredForSubmitSet.size() : 100;

            totalPercentFieldMap.put('TotalFieldPercentage',totalFieldPercentage);
            totalPercentFieldMap.put('RequiredForSavePercentage',requiredForSavePercentage);
            totalPercentFieldMap.put('RequiredForSubmitPercentage',requiredForSubmitPercentage);
        }
        return totalPercentFieldMap;
    }

    global static List<String> validateRequiredQuestion(Id formId, Id parentId){
        List<String> questionReqLst = new List<String>();
        CaptureForm cpForm = getFormResponse(formId,parentId);
        if(cpForm !=null && cpForm.sections !=null){
            for(CaptureSection cpSectionVal: cpForm.sections){
                if(cpSectionVal !=null && cpSectionVal.fields !=null){
                    for(CaptureField cpFieldVal: cpSectionVal.fields){
                        if(cpFieldVal.isBlank){
                            questionReqLst.add(cpFieldVal.questionLabel+' in Section '+cpSectionVal.sectionName);
                        }
                    }
                }
            }
        }
        return questionReqLst;
    }

}