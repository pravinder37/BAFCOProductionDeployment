trigger BAFCOAccountTrigger on Account (before insert) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            BAFCOAccountTriggerHandler.onBeforeInsert(trigger.new);
        }
    }
}