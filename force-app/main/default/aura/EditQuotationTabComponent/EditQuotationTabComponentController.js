({
	init : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");        
        component.set("v.refRecordId", pageReference.state.c__refRecordId);
        component.set("v.leadId", pageReference.state.c__leadId);
        component.set("v.incoTerm", pageReference.state.c__incoTerm);
        component.set("v.isLCL", pageReference.state.c__isLCL);
        component.set("v.isAir", pageReference.state.c__isAir);
        console.log('isAir ** '+ component.get("v.isAir"));
    },
    closeQuickActionModal : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
    }
})