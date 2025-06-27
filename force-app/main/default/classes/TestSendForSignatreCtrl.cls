@isTest 
global with sharing class TestSendForSignatreCtrl{
     //deprecating unused class 
     global with sharing class TestSendForSignatreCtrlMock implements WebServiceMock  {
          global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
                }
     }
}