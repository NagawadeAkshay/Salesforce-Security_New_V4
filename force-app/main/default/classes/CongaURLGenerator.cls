/*
    Generates URL for conga to generate the resultant document (word, pdf etc)
    It works with Dynamic layout as it requires the action button id and
    the business record id as the input.

    If Conga is not installed, then it gracefully returns empty URL
    without generating any error message. All references to conga custom objects
    are intentionally made dynamic to avoid any run time errors when conga is absent.

    **********************************************************
    Audit History
    **********************************************************
    9/18/2016   Shah Kadirmohideen      Created
    04/21/2023       As discussed with Nakul deprecating this class
    **********************************************************  
*/
 public with sharing class CongaURLGenerator {

}