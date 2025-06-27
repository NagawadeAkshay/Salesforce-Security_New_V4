global abstract with sharing  class invokeEmailAction {

global GenericLightningCtrl lightningObject = new GenericLightningCtrl ();
global abstract  String actionToInvokeBefore();
global abstract String actionToInvokeAfter();

}