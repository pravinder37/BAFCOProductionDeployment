trigger BAFCOQuotationTrigger on Quotation__c (before insert,after update) {
    if(trigger.isAfter){        
        if(trigger.isupdate){
            BAFCOQuotationTriggerHandler.afterUpdate(trigger.new,Trigger.oldMap);
        }
    }
    if(trigger.isBefore){   
        if(trigger.isInsert){
            BAFCOQuotationTriggerHandler.beforeInsert(trigger.new);
        }
    }
}