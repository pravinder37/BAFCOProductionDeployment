trigger BAFCORouteTrigger on Route__c (after insert,after update,after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            BAFCORouteTriggerController.updateNameOnOpty(trigger.new);
        }
        if(trigger.isupdate){
            BAFCORouteTriggerController.updateNameOnOpty(trigger.new);
        }
        if(trigger.isDelete){
            BAFCORouteTriggerController.updateNameOnOpty(trigger.old);
        }
    }
}