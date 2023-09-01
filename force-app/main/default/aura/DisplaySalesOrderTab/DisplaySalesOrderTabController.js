({
	init : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        component.set("v.refRecordId", pageReference.state.c__refRecordId);
    },
    closeQuickActionModal : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
    }
})