global with sharing class SendForSignatureCtrl { 
    //deprecating unused class 
      global SendForSignatureCtrl() {}
      global static void docverifysend(String apiKey,String apiSig,String documentId,String documentName,String emails,String messageToSigners,String rName){
      }
      //Method to send document.
    @RemoteAction
    global static void docverifysend(String apiKey,String apiSig,String documentId,String documentName,String emails,String messageToSigners,String rName,String pbId){
    }
}