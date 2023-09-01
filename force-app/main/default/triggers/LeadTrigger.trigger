trigger LeadTrigger on Lead (after update) {
    if(trigger.isUpdate && trigger.isAfter){
        LeadTriggerHandler.accountUpdatesOnConversion(trigger.new);
    }
}