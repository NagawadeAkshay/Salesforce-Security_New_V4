/*
    Class used in case of Captcha Verification .
    **********************************************************
    Audit History

    **********************************************************
    2019-04-04         Shantanu Gadhe            Created.
    **********************************************************
*/
global with sharing class CaptchaCtrl{

    public CaptchaCtrl(){
    }

    @RemoteAction
    global static void  reinitiateCaptcha(String fieldName,String recordId){

    }

    @RemoteAction
    global  static Boolean verifyCaptcha(Map<String,Object> captchaInfo){
    	return false;
    }

    @TestVisible
    private static String makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            return response.getBody();

        } catch(System.Exception e) {

        }
        return '{"success":false}';
    }

    @TestVisible
    private static  string getValueFromJson ( String strJson, String field ){
        JSONParser parser = JSON.createParser(strJson);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                if(parser.getText() == field){
                    parser.nextToken();
                    return parser.getText();
                }
            }
        }
        return null;
    }
}