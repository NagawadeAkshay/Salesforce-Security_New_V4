trigger ConfigChartTrigger on ChartConfig__c  (before insert, before update, after undelete) {
    TriggerHelper th = new TriggerHelper ();
    th.setInternalUniqueID();
}