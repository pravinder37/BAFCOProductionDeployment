({
    init : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        component.set("v.refRecordId", pageReference.state.c__refRecordId);
        if(pageReference.state.c__isEdit != undefined){
            component.set("v.isEdit", pageReference.state.c__isEdit);
        }
        if(pageReference.state.c__optyId != undefined){
            component.set("v.optyId", pageReference.state.c__optyId);
        }
        if(pageReference.state.c__isAir != undefined){
            component.set("v.isAir", pageReference.state.c__isAir);
        }
    },
    closeQuickActionModal : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
    }
})