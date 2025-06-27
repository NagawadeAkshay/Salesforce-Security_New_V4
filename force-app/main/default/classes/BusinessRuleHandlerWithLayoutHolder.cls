global abstract with sharing class BusinessRuleHandlerWithLayoutHolder extends BusinessRuleHandler {

  global Object contextData;

  public void createBusinessRuleWithLayoutHolder(SObject recordObj,DynamicLayoutHolder holder){
    execute(recordObj,holder);
  }
  
    //returns true if no errors are found
    global abstract BusinessRuleResult execute(SObject record, DynamicLayoutHolder holder);
}