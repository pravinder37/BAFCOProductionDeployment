({
    init : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        component.set("v.refRecordId", pageReference.state.c__refRecordId);
        if(pageReference.state.c__cameReviseCompt != undefined){
            component.set("v.cameReviseCompt", pageReference.state.c__cameReviseCompt);
        }
    },
    closeQuickActionModal : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
    }
})