trigger BAFCOOrderTrigger on Order__c (before Insert,after insert, after update,after delete,before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            BAFCOOrderTriggerHandler.beforeAction(trigger.new);
            if(!Trigger_Setting__c.getInstance().Stop_Trigger_Execution__c) {
                BAFCOOrderTriggerHandler.updateOrderName(trigger.new);
            }
        }
        if(trigger.isUpdate){
            BAFCOOrderTriggerHandler.beforeAction(trigger.new);
        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            BAFCOOrderTriggerHandler.sendOrderDetailsOnInsert(trigger.new);
            //if(!Test.isRunningTest()) BAFCOOrderTriggerHandler.updateTargetData(trigger.new); 
        }
        if(trigger.isUpdate){
            BAFCOOrderTriggerHandler.sendOrderDetailsOnUpdate(trigger.new,trigger.oldMap);
            BAFCOOrderTriggerHandler.calculateMargingOnStatusChanges(trigger.new,trigger.oldMap);
            BAFCOOrderTriggerHandler.onAfterUpdate(trigger.new,trigger.oldMap);
        }
        if(trigger.isDelete){
        }
    }
}