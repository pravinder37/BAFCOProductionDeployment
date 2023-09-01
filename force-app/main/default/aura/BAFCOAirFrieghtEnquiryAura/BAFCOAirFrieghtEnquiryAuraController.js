({
    navigateToLC : function(component, event, helper) {
        console.log('refId '+component.get("v.recordId"));
        var device = $A.get("$Browser.formFactor");
        let refId = component.get("v.recordId");
        let isOpportunity = refId.startsWith("006");
        if(isOpportunity == true){
            var action = component.get("c.getAccountId");
            action.setParams({ optyId : refId });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + response.getReturnValue());
                let accId = response.getReturnValue();
                component.set("v.device", device);
                if(device == 'DESKTOP'){
                 var pageReference = {
                type: 'standard__component',
                attributes: {
                    componentName: 'c__createQuoteNewTabAuraComponent'
                },
                state: {
                    c__refRecordId: accId,
                    c__isEdit:'true',
                    c__optyId:refId
                }
            };
            component.set("v.pageReference", pageReference);
            const navService = component.find('navService');
            const pageRef = component.get('v.pageReference');
            const handleUrl = (url) => {
                window.open(url,'_self');
            };
            const handleError = (error) => {
                console.log(error);
            };
            navService.generateUrl(pageRef).then(handleUrl, handleError);
                $A.get("e.force:closeQuickAction").fire();
            }
            else if(device == 'PHONE'){
                component.set("v.refRecordId", accId);
                component.set("v.optyId", component.get("v.recordId"));
                component.set("v.isEdit", 'true');
                
            }    
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        }
        else{
            component.set("v.device", device);
            if(device == 'DESKTOP'){
                 var pageReference = {
                type: 'standard__component',
                attributes: {
                    componentName: 'c__BAFCOAirFrieghtEnquiryAuraTab'
                },
                state: {
                    c__refRecordId: component.get("v.recordId")
                }
            };
            component.set("v.pageReference", pageReference);
            const navService = component.find('navService');
            const pageRef = component.get('v.pageReference');
            const handleUrl = (url) => {
                window.open(url,'_self');
            };
            const handleError = (error) => {
                console.log(error);
            };
            navService.generateUrl(pageRef).then(handleUrl, handleError);
                $A.get("e.force:closeQuickAction").fire();
            }
                else if(device == 'PHONE'){
                component.set("v.refRecordId", component.get("v.recordId"));
            }
        }
    } 
})