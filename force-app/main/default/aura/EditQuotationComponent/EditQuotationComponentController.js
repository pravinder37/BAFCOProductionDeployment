({
	navigateToLC : function(cmp, event, helper) {
		var action = cmp.get("c.getquoteDetails");
        action.setParams({ quoteId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var quoteObj = response.getReturnValue();
                console.log('quoteObj '+JSON.stringify(quoteObj,null,2));
                let incoTerm = quoteObj.incoTerm;
                var leadId = quoteObj.leadId;
                let isLCL = quoteObj.isLCL;
                let isAir = quoteObj.isAir;
                var pageReference = {
                    type: 'standard__component',
                    attributes: {
                        componentName: 'c__EditQuotationTabComponent' 
                    },
                    state: {
                        c__refRecordId: cmp.get("v.recordId"),
                        c__leadId: leadId,
                        c__incoTerm: incoTerm,
                        c__isLCL:  isLCL,
                        c__isAir:isAir
                    }
                };
                cmp.set("v.pageReference", pageReference);
                const navService = cmp.find('navService');
                const pageRef = cmp.get('v.pageReference');
                const handleUrl = (url) => {
                    window.open(url,'_self');
                };
                const handleError = (error) => {
                    console.log('error '+error);
                };
                navService.generateUrl(pageRef).then(handleUrl, handleError);
                    $A.get("e.force:closeQuickAction").fire();
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
})