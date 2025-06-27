/*
    ****************************************************************************************
    Created this trigger to test TriggerHelper.cls. Check TestTriggerHelper.cls for more information
    ****************************************************************************************
*/
trigger SampleObject11Trigger on SampleObject11__c (before insert, before update, before delete, after insert, after update, after delete, after undelete ) {
  TriggerHelper th = new TriggerHelper ();
  th.setInternalUniqueID();
  new SampleObject11TriggerHelper().process();

}