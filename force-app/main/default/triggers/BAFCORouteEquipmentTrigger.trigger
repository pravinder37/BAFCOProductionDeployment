trigger BAFCORouteEquipmentTrigger on Route_Equipment__c (after insert, before Insert,before update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            BAFCORouteEquipmentTriggerController.insertRouteProcumnet(trigger.new);
        }
    }
    if(trigger.isbefore){
        if(trigger.isInsert){
            BAFCORouteEquipmentTriggerController.onbeforeInsert(trigger.new);
        }
        if(trigger.isUpdate){
            BAFCORouteEquipmentTriggerController.onbeforeUpdate(trigger.oldMap,trigger.new);
        }
    }
}