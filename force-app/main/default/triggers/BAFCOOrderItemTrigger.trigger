trigger BAFCOOrderItemTrigger on Order_Item__c (after insert,after update,after delete,before insert,before update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            BAFCOOrderItemTriggerHandler.onAfterInsert(trigger.new);
        }
        
         if(trigger.isUpdate){
             BAFCOOrderItemTriggerHandler.onAfterUpdate(trigger.oldMap,trigger.new);
         }
        if(trigger.isDelete){
            BAFCOOrderItemTriggerHandler.onAfterDelete(trigger.old);
        }
    }
    if(trigger.isBefore){
        if(trigger.isInsert){
            BAFCOOrderItemTriggerHandler.onBeforeInsert(trigger.new);
        }
        if(trigger.isUpdate){
             BAFCOOrderItemTriggerHandler.onBeforeUpdate(trigger.oldMap,trigger.new);
         }
    }
}